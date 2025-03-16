// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Photos
import UIKit
import WebKit
import Shared
import Storage
import SnapKit
import Account
import MobileCoreServices
import Common
import ComponentLibrary
import Redux
import ToolbarKit

import class MozillaAppServices.BookmarkFolderData
import class MozillaAppServices.BookmarkItemData
import struct MozillaAppServices.EncryptedLogin
import enum MozillaAppServices.BookmarkRoots
import enum MozillaAppServices.VisitType

extension BrowserViewController {
    @_dynamicReplacement(for: tab(_:didCreateWebView:))
    func ims_tab(_ tab: Tab, didCreateWebView webView: WKWebView) {
        self.tab(tab, didCreateWebView: webView)
        if let dwkwebView = webView as? TabWebView {
            dwkwebView.DSUIDelegate = self
        } else {
            webView.uiDelegate = self
        }
        
        let imsScript = IMSScript(tab: tab)
        imsScript.delegate = self
        tab.addContentScript(imsScript, name: IMSScript.name())
    }
    
    @_dynamicReplacement(for: tab(_:willDeleteWebView:))
    func ims_tab(_ tab: Tab, willDeleteWebView webView: WKWebView) {
        self.tab(tab, willDeleteWebView: webView)
        DispatchQueue.main.async {
            if let dwkwebView = webView as? TabWebView {
                dwkwebView.DSUIDelegate = nil
            } else {
                webView.uiDelegate = nil
            }
        }
    }
    
    @_dynamicReplacement(for: webView(_:decidePolicyFor:decisionHandler:))
    func ims_webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        self.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        guard let url = navigationAction.request.url,
              let tab = tabManager[webView]
        else {
            return
        }
        if ["http", "https", "blob", "file"].contains(url.scheme) {
            
        }
        if tab.changedUserAgent {
            let platformSpecificUserAgent = UserAgent.ims_oppositeUserAgent(url: url)
            webView.customUserAgent = platformSpecificUserAgent
        } else {
            webView.customUserAgent = UserAgent.ims_getUserAgent(url: url)
        }
    }
    
    struct IMSAssociatedKeys {
        static var controllerKey: UInt8 = 0
    }
    
    var imsController: IMSBrowserController? {
        get {
            objc_getAssociatedObject(self, &IMSAssociatedKeys.controllerKey) as? IMSBrowserController
        }
        set {
            objc_setAssociatedObject(self, &IMSAssociatedKeys.controllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @_dynamicReplacement(for: subscribeToRedux)
    func ims_subscribeToRedux() {
        self.subscribeToRedux()
        if (imsController == nil) {
            self.imsController = IMSBrowserController(windowUUID: windowUUID, parent: self)
            self.imsController?.subscribeToRedux()
        }
    }
    
    @_dynamicReplacement(for: tabManager(_:didSelectedTabChange:previousTab:isRestoring:))
    func ims_tabManager(_ tabManager: TabManager, didSelectedTabChange selectedTab: Tab, previousTab: Tab?, isRestoring: Bool) {
        self.tabManager(tabManager, didSelectedTabChange: selectedTab, previousTab: previousTab, isRestoring: isRestoring)
        if let url = selectedTab.webView?.url, InternalURL.scheme != url.scheme,
           let imsScript = selectedTab.getContentScript(name: IMSScript.name()) as? IMSScript {
            updateTranslatePageStatus(for: selectedTab, pageStatus: imsScript.pageStatus)
        } else {
            updateTranslatePageStatus(for: selectedTab, pageStatus: IMSScript.defaultPageStatus)
        }
    }
    
    @_dynamicReplacement(for: navigateInTab(tab:to:webViewStatus:))
    func ims_navigateInTab(tab: Tab, to navigation: WKNavigation? = nil, webViewStatus: WebViewUpdateStatus) {
        self.navigateInTab(tab: tab, to: navigation, webViewStatus: webViewStatus)
        guard let webView = tab.webView else { return }
        if let url = webView.url {
            if (!InternalURL.isValid(url: url)) && !url.isFileURL {
                webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).getPageStatusAsync()")
            }
        }
    }
    
    @_dynamicReplacement(for: webView(_:didStartProvisionalNavigation:))
    func ims_webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
        self.webView(webView, didStartProvisionalNavigation: navigation)
        if let url = webView.url {
            updateTranslatePageStatus(for: tabManager.selectedTab, pageStatus: "Original")
        }
    }
    
    func updateTranslatePageStatus(for tab: Tab?, pageStatus: String) {
        switch pageStatus {
        case "Translated":
            imsStore.dispatch(
                IMSToolbarTranslateAction(
                    windowUUID: windowUUID,
                    actionType: IMSToolbarTranslateActionType.translated
                )
            )
        case "Original":
            imsStore.dispatch(
                IMSToolbarTranslateAction(
                    windowUUID: windowUUID,
                    actionType: IMSToolbarTranslateActionType.origin
                )
            )
        default:
            break
        }
    }
    
    
    class IMSBrowserController: StoreSubscriber {
        
        let windowUUID: WindowUUID
        weak var parent: BrowserViewController?
        
        init(windowUUID: WindowUUID, parent: BrowserViewController) {
            self.windowUUID = windowUUID
            self.parent = parent
        }
        
        
        func newState(state: IMSBrowserViewControllerState) {
            guard let actionType = state.actionType else { return }
            switch actionType {
            case .none:
                break
            case .translatePage:
                translatePageAction()
            case .restorePage:
                restorePageAction()
            case .togglePopup:
                togglePopupAction()
            }
        }
        
        func translatePageAction() {
            StoreConfig.translateNum += 1
            guard let tab = parent?.tabManager.selectedTab, let webView = tab.webView else { return }
            webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).translatePage()") { object, error in
                webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).getPageStatusAsync()") {_,_ in
                    
                }
            }
        }
        
        func restorePageAction() {
            guard let tab = parent?.tabManager.selectedTab, let webView = tab.webView else { return }
            webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).restorePage()") { object, error in
                webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).getPageStatusAsync()") {_,_ in
                    
                }
            }
        }
        
        func togglePopupAction() {
            guard let tab = parent?.tabManager.selectedTab, let webView = tab.webView else { return }
            webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).togglePopup(\"right: unset; bottom: unset; left: 50%; top: 0; transform: translateX(-50%);\", false)") { object, error in
                
            }
        }
        
        func subscribeToRedux() {
            imsStore.dispatch(
                IMSScreenAction(
                    windowUUID: windowUUID,
                    actionType: ScreenActionType.showScreen,
                    screen: .browserViewController
                )
            )
            let uuid = windowUUID
            imsStore.subscribe(self, transform: {
                return $0.select({ appState in
                    return IMSBrowserViewControllerState(appState: appState, uuid: uuid)
                })
            })
        }
        
        func unsubscribeFromRedux() {
            imsStore.dispatch(
                IMSScreenAction(
                    windowUUID: windowUUID,
                    actionType: ScreenActionType.closeScreen,
                    screen: .browserViewController
                )
            )
        }
    }
}

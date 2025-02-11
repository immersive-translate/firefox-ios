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
    
    func showIMSUpgradeViewController() {

        let navigationController = DismissableNavigationViewController()
        let coordinator = IMSUpgradeCoordinator(
            router: DefaultRouter(navigationController: navigationController),
            windowUUID: windowUUID,
            profile: profile
        )
        coordinator.start()
        
        self.present(navigationController, animated: true)
    }
}

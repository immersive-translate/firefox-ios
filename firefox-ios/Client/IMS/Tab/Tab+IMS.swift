// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import ObjectiveC.runtime

protocol LegacyTabIMSDelegate: AnyObject {
    
    func getBrowserVC() -> BrowserViewController?
}

class LegacyTabIMSDelegateWrapper {
    weak var imsTabDelegate: LegacyTabIMSDelegate?
    
    init(imsTabDelegate: LegacyTabIMSDelegate?) {
        self.imsTabDelegate = imsTabDelegate
    }
}

extension BrowserViewController: LegacyTabIMSDelegate {
    @_dynamicReplacement(for: tabManager(_:didAddTab:placeNextToParentTab:isRestoring:))
    func ims_tabManager(_ tabManager: TabManager, didAddTab tab: Tab, placeNextToParentTab: Bool, isRestoring: Bool) {
        self.tabManager(tabManager, didAddTab: tab, placeNextToParentTab: placeNextToParentTab, isRestoring: isRestoring)
        tab.imsTabDelegateWrapper = .init(imsTabDelegate: self)
    }
    
    func getBrowserVC() -> BrowserViewController? {
        return self
    }
    
    
}

extension Tab {
    
    struct IMSTabAssociatedKeys {
        static var imsTabDelegateKey: UInt8 = 0
    }
    
    var imsTabDelegateWrapper: LegacyTabIMSDelegateWrapper? {
        get {
            // 获取关联对象
            return objc_getAssociatedObject(self, &IMSTabAssociatedKeys.imsTabDelegateKey) as? LegacyTabIMSDelegateWrapper
        }
        set {
            // 设置关联对象
            objc_setAssociatedObject(self, &IMSTabAssociatedKeys.imsTabDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @_dynamicReplacement(for: createWebview(with:configuration:))
    func ims_createWebview(with restoreSessionData: Data? = nil, configuration: WKWebViewConfiguration) {
        self.createWebview(with: restoreSessionData, configuration: configuration)
        guard let webView = self.webView else { return }
        webView.disableJavascriptDialogBlock(false);
        webView.addJavascriptObject(LocalStorageJSObject(), namespace: "localStorage");
        webView.addJavascriptObject(HttpClientJSObject(), namespace: "httpClient");
        
        let businessJSObject = BusinessJSObject { [self] params in
            var text = "";
            if let title = params["title"], !title.isEmpty {
                text = title;
            }
            if let content = params["content"], !content.isEmpty {
                text = text + "\n" + content
            }
            let browserVC = self.imsTabDelegateWrapper?.imsTabDelegate?.getBrowserVC()
            browserVC?.navigationHandler?.showShareSheet(shareType: .site(url: URL(string: params["url"] ?? "")!), shareMessage: ShareMessage(message: text, subtitle: nil), sourceView: browserVC!.view!, sourceRect: nil, toastContainer: browserVC!.view!, popoverArrowDirection: .up)
            
        } configDefaultBrowserBlock: {
            DefaultApplicationHelper().open(URL(string: "fennec://deep-link?url=default-browser/tutorial")!)
        };
        webView.addJavascriptObject(businessJSObject, namespace: "business");
        let windowJSObejct = WindowJSObject { [self] url in
            let browserVC = self.imsTabDelegateWrapper?.imsTabDelegate?.getBrowserVC()
            browserVC?.openURLInNewTab(URL(string: url))
        };
        
        webView.addJavascriptObject(windowJSObejct, namespace: "window");
        
        webView.setDebugMode(false)
        
        NotificationCenter.default.addObserver(forName: .NeedRefreshImmersiveTranslateJsInject, object: nil, queue: .main) { _ in
            UserScriptManager.shared.injectUserScriptsIntoWebView(self.webView, nightMode: self.nightMode, noImageMode: self.noImageMode)
        }
    }
}

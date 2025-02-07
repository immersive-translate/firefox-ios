// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import Common
@preconcurrency import WebKit
import Shared
import UIKit
import Photos
import SafariServices

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
}

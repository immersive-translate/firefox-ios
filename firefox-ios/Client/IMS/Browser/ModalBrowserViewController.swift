// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Foundation
import Storage
import Shared
import SiteImageView
import WebKit

class ModalBrowserViewController: UIViewController, WKUIDelegate {
    
    
    weak var coordinator: ModalBrowserCoordinator?
    let url: URL
    let windowUUID: WindowUUID
    let profile: Profile
    
    
    
    lazy var webViewTab = {
        let tab = Tab(profile: profile, windowUUID: windowUUID)
        return tab
    }()
    
    init(url: URL, profile: Profile, windowUUID: WindowUUID) {
        self.url = url
        self.windowUUID = windowUUID
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        webViewTab.createWebview(configuration: WKWebViewConfiguration())
        if let webView = webViewTab.webView {
            webView.DSUIDelegate = self
            webView.navigationDelegate = self
            webView.frame = self.view.bounds
            webView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(webView)
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        webViewTab.loadRequest(URLRequest(url: url))
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        coordinator?.webViewDidClose()
    }
    
    
}

extension ModalBrowserViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        
        guard let url = navigationAction.request.url
        else {
            decisionHandler(.cancel)
            return
        }
        
        if ["http", "https", "blob", "file"].contains(url.scheme) {
            webView.customUserAgent = UserAgent.getUserAgent(domain: url.baseDomain ?? "")

            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
    }
}

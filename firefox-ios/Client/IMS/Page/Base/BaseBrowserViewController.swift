// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import WebKit

class BaseBrowserViewController: BaseViewController {
    var url = ""
    private var urlURL: URL?

    override var showBottomLine: Bool {
        return false
    }
    
    private lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.navigationDelegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let  rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "login_close"), style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.backgroundColor = ThemeColor.ZX.FFFFFF
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        guard let url = URL(string: url) else {
            return
        }
        urlURL = url
        webView.load(URLRequest(url: url))
    }
    
    @objc
    private func close() {
        dismiss(animated: true)
    }
}

extension BaseBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}

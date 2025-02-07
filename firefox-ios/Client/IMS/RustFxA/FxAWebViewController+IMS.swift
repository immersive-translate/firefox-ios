// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension FxAWebViewController {
    
    @_dynamicReplacement(for:afterInit)
    func ims_afterInit() {
        if let dwkwebView = webView as? TabWebView {
            dwkwebView.DSUIDelegate = self
        } else {
            webView.uiDelegate = self
        }

    }

}

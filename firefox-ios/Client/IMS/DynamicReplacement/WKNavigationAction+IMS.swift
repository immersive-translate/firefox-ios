// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension WKNavigationAction {
    @_dynamicReplacement(for: canOpenExternalApp)
    var ims_canOpenExternalApp: Bool {
        guard let urlShortDomain = request.url?.shortDomain else { return false }
        
        if urlShortDomain == URL.mozPublicScheme {
            return false
        }
        
        if !IMSAPPConfigUtils.shared.config.appHostWhiteList.contains(urlShortDomain) {
            return false
        }
        
        if let url = URL(string: "\(urlShortDomain)://"), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}

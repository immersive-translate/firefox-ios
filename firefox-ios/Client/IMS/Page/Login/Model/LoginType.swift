// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

enum LoginType {
    case google
    case email
    case apple
    case facebook
    case weixin
    
    var title: String {
        switch self {
        case .google:
            return "Imt.login.btn_google".i18nImt()
        case .email:
            return "Imt.login.btn_email".i18nImt()
        case .apple:
            return "Imt.login.btn_apple".i18nImt()
        case .facebook:
            return "Imt.login.btn_fb".i18nImt()
        case .weixin:
            return "Imt.login.btn_wx".i18nImt()
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .google:
            return UIImage(named: "google_icon")
        case .email:
            return UIImage(named: "email_icon")
        case .apple:
            return UIImage(named: "apple_icon")
        case .facebook:
            return UIImage(named: "facebook_icon")
        case .weixin:
            return UIImage(named: "wechat_icon")
        }
    }
}

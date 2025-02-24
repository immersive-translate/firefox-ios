// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSAppUrlConfig {
    
    enum IMSAppENV {
        case product
        case dev
    }
    
    static let immersiveTranslateUser = "https://download.immersivetranslate.com/immersive-translate.user.js"
    
    static let dash = "https://dash.immersivetranslate.com/"
    
    static let baseAPIURL = {
        switch IMSAppManager.shared.currentEnv {
        case .dev:
            return "https://test-api2.immersivetranslate.com"
        case .product:
            return "https://api2.immersivetranslate.com"
        }
    }()
    
    static let baseHomeURL = {
        switch IMSAppManager.shared.currentEnv {
        case .product:
            return "https://immersivetranslate.com"
        case .dev:
            return "https://test.immersivetranslate.com"
        }
    }()
    
    static let usage = baseHomeURL + "/docs/usage/"
    
    static let changelog  = baseHomeURL + "/docs/CHANGELOG/"
    
    static let terms = baseHomeURL + "/docs/TERMS/"
    
    static let privacy = baseHomeURL + "/docs/PRIVACY/"
    
    static let login = baseHomeURL + "/accounts/login"
    
    static let purchaseSuccess = baseHomeURL + "/accounts/success"
}

struct IMSAppManager {
    static let shared = IMSAppManager()
    
    var currentEnv: IMSAppUrlConfig.IMSAppENV = .product
    
    var topSiteService = IMSAPPTopSiteService()
    
}

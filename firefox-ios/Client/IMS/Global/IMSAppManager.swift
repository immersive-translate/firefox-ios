// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSAppUrlConfig {
    static let immersiveTranslateUser = "https://download.immersivetranslate.com/immersive-translate.user.js"
    static let dash = "https://dash.immersivetranslate.com/"
    
    static let usage = "https://immersivetranslate.com/docs/usage/"
    
    static let changelog  = "https://immersivetranslate.com/docs/CHANGELOG/"
    
    static let terms = "https://immersivetranslate.com/docs/TERMS/"
    
    static let privacy = "https://immersivetranslate.com/docs/PRIVACY/"
    static let baseURL =  "https://test-api2.immersivetranslate.com"
}

struct IMSAppManager {
    static let shared = IMSAppManager()
}

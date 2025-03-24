// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Shared

enum APPAPI {
    struct GlobalConfigRequest: IMSAPIRequest {
        typealias DataResponse = IMSAPPConfig
        
        var path: String {
            return "/v1/app/globalconfig"
        }
        
        var parameters: [String: Any]? {
            return nil
        }
    }
}

extension APPAPI {
    
    struct LoadOnboardingTranslationsModel: Codable {

        @DefaultEmptyString
        var english: String = ""

        @DefaultEmptyString
        var key: String = ""

        @DefaultEmptyString
        var localizedText: String = ""
        
        @DefaultEmptyString
        var zhcnText: String = ""
    }

    
    struct LoadOnboardingTranslationsRequest: IMSAPIRequest {
        typealias DataResponse = [LoadOnboardingTranslationsModel]
        
        /// 母语
        var language: String
        
        var path: String {
            return "/v1/app/load-onboarding-translations"
        }
        
        var parameters: [String: Any]? {
            return [
                "language": language
            ]
        }
    }
}

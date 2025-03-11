// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Shared

enum APPAPI {
    struct GlobalConfigRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel

        var path: String {
            return "/v1/app/globalconfig"
        }
        
        var parameters: [String: Any]? {
            return [
                "platForm": "ios",
                "appVersion": AppInfo.appVersion,
            ]
        }
    }
}

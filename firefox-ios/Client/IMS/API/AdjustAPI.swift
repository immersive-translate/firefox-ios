// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

enum AdjustAPI {
    struct EventRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var path: String {
            return "/adjust/event"
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var method: APIRequestMethod {
            return .post
        }
    }
    
    struct SessionRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var path: String {
            return "/adjust/session"
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var method: APIRequestMethod {
            return .post
        }
    }
}

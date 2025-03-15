// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

public struct ImgUploadModel: Codable {
    @DefaultEmptyString
    var objectKey: String = ""

    @DefaultEmptyString
    var url: String = ""
}

enum FeedbackAPI {
}

extension FeedbackAPI {
    struct ImgUploadRequest: IMSAPIRequest {
        var fileInfo: IMSAPIFile
        
        typealias DataResponse = ImgUploadModel
        
        var path: String {
            return "/v1/feed-back/img-upload"
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var file: IMSAPIFile? {
            return fileInfo
        }
    }
    
    
    struct WebReportLogRequest: IMSAPIRequest {
        var reason: String
        var feedType: FeedType
        var imageArr: [ImgUploadModel]
        var contactInfo: String?
        
        typealias DataResponse = PlaceholderResponseModel
        
        var path: String {
            return "/v1/feed-back/web-report-log"
        }
        
        var parameters: [String: Any]? {
            return [
                "reason": reason,
                "feedType": feedType.type,
                "metaData": [
                    "objectKeyList": imageArr.compactMap({ $0.objectKey })
                ],
                "contactInfo": contactInfo ?? "",
            ]
        }
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Alamofire
import LTXiOSUtils
import SwiftyJSON
import Adjust
import Common
import Shared

final class TrackManager {
    static let shared = TrackManager()

    private init() {}
}

extension TrackManager {
    func event(_ name: String, param: [String: Any]? = nil) {
        sendEvent(name: name, param: param)
    }
}

extension TrackManager {
    private func sendEvent(name: String, param: [String: Any]? = nil) {
        guard let url = URL(string: "\(IMSAppUrlConfig.analyticsURL)/collect") else {
            return
        }
        let parameters: [String: Any] = [
            "nonce": UUID().uuidString,
            "subject": "user_behaviour",
            "logs": [buildLog(eventName: name, param: param)]
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .response { response in
                switch response.result {
                case .success(let data):
                    /// data是一个字符串，可以用string解析，是一个ok
//                    Log.d("Response Data: \(data)")
                    ()
                case .failure(let error):
                    Log.d("Error: \(error)")
                }
            }
    }
    
    private func buildLog(eventName: String, param: [String: Any]?) -> String {
        let dict = [
            "os_name": UIDevice.current.systemName,
            "os_version": UIDevice.current.systemVersion,
            "os_version_name": UIDevice.current.systemVersion,
            "page_type": "app",
            "platform_type": getUserInterfaceIdiomName(),
            "version": AppInfo.appVersion,
            "event_name": eventName,
            "device_id": Adjust.adid(),
        ]
        return JSON(dict).rawString([:]) ?? ""
    }
    
    func getUserInterfaceIdiomName() -> String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iPhone"
        case .pad:
            return "iPad"
        case .tv:
            return "Apple TV"
        case .carPlay:
            return "CarPlay"
        case .mac:
            return "Mac"
        default:
            return "Unknown"
        }
    }
}

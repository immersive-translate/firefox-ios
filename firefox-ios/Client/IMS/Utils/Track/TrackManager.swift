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
    func event(_ name: String, params: [String: Any]? = nil) {
        sendEvent(name: name, params: params)
    }
}

extension TrackManager {
    private func sendEvent(name: String, params: [String: Any]? = nil) {
        guard let url = URL(string: "\(IMSAppUrlConfig.analyticsURL)/collect") else {
            return
        }
        let parameters: [String: Any] = [
            "nonce": UUID().uuidString,
            "subject": "user_behaviour",
            "logs": [buildLog(eventName: name, params: params)]
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
    
    private func buildLog(eventName: String, params: [String: Any]?) -> String {
        var dict: [String: Any] = [
            "os_name": UIDevice.current.systemName,
            "os_version": UIDevice.current.systemVersion,
            "os_version_name": UIDevice.current.systemVersion,
            "page_type": "app",
            "platform_type": getUserInterfaceIdiomName(),
            "version": AppInfo.appVersion,
            "event_name": eventName,
            "device_id": Adjust.adid() as Any,
        ]
        if let params = params {
            dict.merge(processParams(params)) { (_, new) in new }
        }
        return JSON(dict).rawString([:]) ?? ""
    }
    
    private func processParams(_ input: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        var intIndex = 1
        var charIndex = 1
        
        for value in input.values {
            if let intValue = value as? Int {
                result["ex_int_arg\(intIndex)"] = intValue
                intIndex += 1
            } else {
                result["ex_char_arg\(charIndex)"] = "\(value)"
                charIndex += 1
            }
        }
        
        return result
    }
    
    private func getUserInterfaceIdiomName() -> String {
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

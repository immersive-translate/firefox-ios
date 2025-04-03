// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import Adjust

final class AdjustTrackManager {
    
    static let shared = AdjustTrackManager()
    
    private init() {}
}

extension AdjustTrackManager {
    func event(_ eventToken: String, params: [String: Any]? = nil) {
        // imtSessionId 下单返回的
        
    }
    
    func session(_ eventToken: String, params: [String: Any]? = nil) {
        // imtSessionId 下单返回的
    }
}


extension TrackManager {
    private func sendEvent(name: String, params: [String: Any]? = nil) {
        guard let url = URL(string: "\(IMSAppUrlConfig.analyticsURL)/collect") else {
            return
        }
        let parameters: [String: Any] = [
            "s2s": true,
            "eventToken": name,
            "idfa": TrackManager.shared.deviceID,
            "createdAt": "",
            "callbackParams": "",
            "partnerParams": "",
            "currency": "",
            "revenue": "",
        ]
    }
    
    private func sendSession(name: String, params: [String: Any]? = nil) {
        guard let url = URL(string: "\(IMSAppUrlConfig.analyticsURL)/collect") else {
            return
        }
        let parameters: [String: Any] = [
            "s2s": true,
            "appVersion": "",
            "createdAtUnix": "",
            "osName": "ios",
            "rida": ""
        ]
    }
}

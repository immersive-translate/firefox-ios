// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Adjust
import Common
import SwiftyJSON

final class AdjustTrackManager {
    static let shared = AdjustTrackManager()

    private init() {}
}

extension AdjustTrackManager {
    func event(_ eventToken: String, revenue: (Double, String)? = nil, extraParams: [String: Any]? = nil, callbackParams: [String: Any]? = nil) {
        if eventToken.isEmpty {
            return
        }
        // imtSessionId 下单返回的
        sendEvent(name: eventToken, revenue: revenue, extraParams: extraParams, callbackParams: callbackParams)
    }
}

extension AdjustTrackManager {
    private func sendEvent(name: String, revenue: (Double, String)?, extraParams: [String: Any]? = nil, callbackParams: [String: Any]? = nil) {
        var parameters: [String: Any] = [
            "attribution_deeplink": 1,
            "environment": IMSAppManager.shared.currentEnv == .dev ? "sandbox" : "production",
            "app_version": AppInfo.appVersion,
            "country": getCurrentCountryCode(),
            "language": Bundle.main.preferredLocalizations.first ?? "",
            "os_name": "ios",
            "os_version": UIDevice.current.systemVersion,
            "cpu_type": getCPUArchitecture(),
            "device_type": getCurrentDeviceTypeName(),
            "device_name": DeviceInfo.specificModelName,
            "adid": Adjust.adid() ?? "",
            "bundle_id": AppInfo.bundleIdentifier,
            "idfa": Adjust.idfa() ?? "",
            "idfv": Adjust.idfv() ?? "",
            "eventToken": name,
            "callbackParams": callbackParams != nil ? (JSON(callbackParams ?? [:]).rawString([:]) ?? "") : "",
            "revenue": revenue?.0 ?? 0.0,
            "currency": revenue?.1 ?? "",
        ]
        if let extraParams = extraParams {
            parameters.merge(extraParams) { old, _ in
                old
            }
        }

        let request = AdjustAPI.EventRequest(param: parameters)
        APIService.sendRequest(request) { response in
            switch response.result.validateResult {
            case .success:
                ()
            case let .failure(message, _):
                ()
            }
        }
    }

    func getCurrentDeviceTypeName() -> String {
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

    func getCPUArchitecture() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return identifier
    }

    func getCurrentCountryCode() -> String {
        return Locale.current.regionCode ?? "Unknown"
    }
}

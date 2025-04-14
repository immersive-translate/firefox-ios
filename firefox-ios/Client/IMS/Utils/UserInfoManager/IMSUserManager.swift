// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftyJSON

final class IMSUserManager {
    static let userInfoUpdateNotification = Notification.Name(rawValue: "IMS_USER_INFO_UPDATE")

    static let shared = IMSUserManager()

    private init() {}
}

extension IMSUserManager {
    func setUserInfo(info: JSON) {
        WebLocalStorageManager.shared.set(info.rawString(options: []), forKey: IMSAccountConfig.localStoreKey)
    }
    
    func getUserInfo() -> IMSUser? {
        let userInfoString = WebLocalStorageManager.shared.string(forKey: IMSAccountConfig.localStoreKey)
        guard let data = userInfoString?.data(using: .utf8) else { return nil}
        let userInfo = try? JSONDecoder().decode(IMSUser.self, from: data)
        return userInfo
    }
}

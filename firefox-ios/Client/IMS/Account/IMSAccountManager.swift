// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import StoreKit

struct IMSAccountConfig {
    static let localStoreKey = "immersiveTranslateCacheKey_user_info"
    static let oneYearProductId = "1year"
    static let testToken = "temp-token-2023-a-b"
}



class IMSAccountManager {
    static let shard = IMSAccountManager()
    
    lazy var iap: IMSIAPAppleService = {
        return IMSIAPAppleService()
    }()
    
    private init() {}
    
    func current() -> IMSAccountInfo? {
        let userInfoString = WebLocalStorageManager.shared.string(forKey: IMSAccountConfig.localStoreKey)
        guard let data = userInfoString?.data(using: .utf8) else { return nil}
        let userInfo = try? JSONDecoder().decode(IMSAccountInfo.self, from: data)
        return userInfo
    }
    
    func setup() {
        self.iap.observeTransactions()
    }
}

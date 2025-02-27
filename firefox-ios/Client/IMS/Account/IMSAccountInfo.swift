// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


struct IMSAccountInfo: Codable {
    let subscription: IMSAccountSubscription?

    let token: String
    let email: String?
    let uid: UInt64?
    let iosPlanTier: String?
    
    static func from(token: String, resp: IMSAccountInfoResp) -> IMSAccountInfo {
        return IMSAccountInfo(
            subscription: resp.subscription,
            token: token,
            email: resp.email,
            uid: resp.uid,
            iosPlanTier: resp.iosPlanTier
        )
    }
}

struct IMSAccountInfoResp: Codable {
    let subscription: IMSAccountSubscription?
    let uid: UInt64?
    let email: String?
    //  "trial"表示还未进行过试用， "upgrade" 表示已经使用过试用
    let iosPlanTier: String?
}

struct IMSAccountSubscription: Codable {
    let subscriptionType: IMSResponseConfiGoodType?
    let subscriptionTo: String?
    let paymentChannel: String?
    
}

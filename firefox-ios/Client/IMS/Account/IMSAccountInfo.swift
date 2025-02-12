// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


struct IMSAccountInfo: Codable {
    let subscription: IMSAccountSubscription?

    let token: String
    let email: String?
}

struct IMSAccountInfoResp: Codable {
    let subscription: IMSAccountSubscription?
    let email: String?
}

struct IMSAccountSubscription: Codable {
    let subscriptionType: IMSResponseConfiGoodType?
    let subscriptionTo: String?
    
}

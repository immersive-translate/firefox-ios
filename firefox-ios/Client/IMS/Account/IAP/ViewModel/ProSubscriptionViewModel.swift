// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import StoreKit

struct ProSubscriptionInfo: Identifiable {
    let id = UUID()
    let serverProduct: IMSResponseConfiGood
    let appleProduct: StoreKit.Product
}

struct ProSubscriptionConfig {
    let channelName: String
    let channelIco: String
    let channelCode: String
    let symbol: String
    
    let infos: [ProSubscriptionInfo]
}

class ProSubscriptionViewModel: ObservableObject {
    let config: ProSubscriptionConfig
    
    @Published
    var selectedConfiGoodType: IMSResponseConfiGoodType = .monthly
    
    init(config: ProSubscriptionConfig) {
        self.config = config
    }
}

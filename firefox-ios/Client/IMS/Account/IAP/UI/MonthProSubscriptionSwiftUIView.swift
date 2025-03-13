// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct MonthProSubscriptionSwiftUIView: View {
    let info: ProSubscriptionInfo
    let fromSource: ProSubscriptionFromSource
    var body: some View {
        VStack(spacing: 0) {
            MonthProSubscriptionHeaderSwiftUIView(info: info, fromSource: fromSource)
                .frame(maxWidth: .infinity)
                .frame(height: 191 + 26)
            
            MonthProSubscriptionListSwiftUIView()
                .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
    }
}


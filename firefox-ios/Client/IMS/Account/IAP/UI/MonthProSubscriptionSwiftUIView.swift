// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct MonthProSubscriptionSwiftUIView: View {
    var body: some View {
        VStack(spacing: 0) {
            MonthProSubscriptionHeaderSwiftUIView()
                .frame(maxWidth: .infinity)
                .frame(height: 191 + 26)
            
            MonthProSubscriptionListSwiftUIView()
                .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MonthProSubscriptionSwiftUIView()
}

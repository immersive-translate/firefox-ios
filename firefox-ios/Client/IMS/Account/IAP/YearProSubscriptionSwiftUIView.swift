// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct YearProSubscriptionSwiftUIView: View {
    var body: some View {
        VStack(spacing: 0) {
            YearProSubscriptionHeaderSwiftUIView()
            YearProSubscriptionListSwiftUIView()
            
            Spacer()
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    YearProSubscriptionSwiftUIView()
}

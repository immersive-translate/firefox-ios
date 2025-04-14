// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct ProSubscritionBottom: View {
    @ObservedObject var viewModel: ProSubscriptionViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                viewModel.showTerms()
            } label: {
                Text("\(String.IMS.IAP.termsOfService)")
                    .font(Font.custom("PingFang SC", size: 12))
                    .foregroundColor(Color(uiColor: UIColor(hexString: "#CCCCCC").withDarkColor("#5C5C5C")))
            }
            .frame(maxWidth: .infinity)

            Button {
                viewModel.showPrivacy()
            } label: {
                Text("\(String.IMS.IAP.privacyPolicy)")
                    .font(Font.custom("PingFang SC", size: 12))
                    .foregroundColor(Color(uiColor: UIColor(hexString: "#CCCCCC").withDarkColor("#5C5C5C")))
            }
            .frame(maxWidth: .infinity)
            
            Button {
                viewModel.restorePurchases()
            } label: {
                Text("\(String.IMS.IAP.restorePurchases)")
                    .font(Font.custom("PingFang SC", size: 12))
                    .foregroundColor(Color(uiColor: UIColor(hexString: "#CCCCCC").withDarkColor("#5C5C5C")))
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 60)
    }
}

#Preview {
    ProSubscritionBottom(viewModel: .init())
}

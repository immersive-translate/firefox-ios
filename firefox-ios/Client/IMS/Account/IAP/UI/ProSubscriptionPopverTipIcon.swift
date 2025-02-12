// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import SwiftUI

struct ProSubscriptionPopverTipIcon: View {
    let tipMessage: String
    @State private var showPopover = false
    var body: some View {
        Button {
            showPopover = true
        } label: {
            Image("iap_year_info_icon")
                .resizable()
              .frame(width: 16, height: 16)
        }
        .customPopover(isPresented: $showPopover, content: {
            Text(tipMessage)
                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 14))
                .foregroundColor(Color.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.black)
                .frame(maxWidth: 250)
        })
    }
}

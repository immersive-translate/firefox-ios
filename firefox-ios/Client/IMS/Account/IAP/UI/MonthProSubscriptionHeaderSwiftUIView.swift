// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct MonthProSubscriptionHeaderSwiftUIView: View {
    let info: ProSubscriptionInfo
    let fromSource: ProSubscriptionFromSource
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                if fromSource == .upgrade {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 241)
                        .background(
                            Image("iap_month_bg")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        )
                }

                ZStack(alignment: .top) {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 0){
                            Spacer()
                                .frame(height: 24)
                            
                            HStack(spacing: 0){
                                Spacer().frame(width: 24)
                                
                                Text("\(String.IMS.IAP.monthlyProMembership)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(uiColor: UIColor(hexString: "#333333").withDarkColor("#D8D8D8")))
                                
                                Spacer().frame(width: 12)
                                
                                Image("iap_year_pro_icon")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Spacer()
                            }
                            
                            Spacer()
                                .frame(height: 16)

                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Spacer().frame(width: 24)
                                Text(IMSIAPAppleService.formatPrice(product: info.appleProduct))
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 48)
                                    )
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Text("/\(String.IMS.IAP.month)")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 24)
                                    )
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Spacer()

                            }

                            Spacer()

                        }
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 201)
                        .foregroundColor(.clear)
                        .background(
                            Image("iap_month_header_bg")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        )
                        .cornerRadius(24)
                    }
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 201)

                }
                .frame(maxWidth: .infinity)

                .padding(.horizontal, 20)
                .padding(.top, 26)

            }
            .ignoresSafeArea()
        }
    }
}


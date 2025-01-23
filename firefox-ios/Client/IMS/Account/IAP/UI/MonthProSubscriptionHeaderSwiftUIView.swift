// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct MonthProSubscriptionHeaderSwiftUIView: View {
    let info: ProSubscriptionInfo
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 241)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(
                                    color: Color(
                                        red: 0.16, green: 0.63, blue: 1
                                    ).opacity(0.4), location: 0.00),
                                Gradient.Stop(
                                    color: Color(
                                        red: 0.16, green: 0.63, blue: 1
                                    ).opacity(0), location: 0.67),
                            ],
                            startPoint: UnitPoint(x: 0.41, y: 0),
                            endPoint: UnitPoint(x: 0.3, y: 1)
                        )
                    )

                ZStack(alignment: .top) {
                    ZStack(alignment: .bottom) {
                        VStack {
                            HStack {
                                Text("月费Pro会员")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(
                                        Color(red: 0.2, green: 0.2, blue: 0.2))
                                Image("iap_year_pro_icon")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                Spacer()
                            }
                            .padding(.leading, 24)
                            .padding(.top, 24)

                            HStack {
                                Text(IMSIAPAppleService.formatPrice(product: info.appleProduct))
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 48)
                                    )
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Text("/月")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 24)
                                    )
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Spacer()

                            }
                            .padding(.leading, 24)
                            .padding(.top, 16)

                            Spacer()

                        }
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 191)
                        .foregroundColor(.clear)
                        .frame(width: 335, height: 191)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(
                                        color: .white, location: 0.39),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.75, green: 0.84, blue: 1),
                                        location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.03, y: 0.03),
                                endPoint: UnitPoint(x: 0.94, y: 1.13)
                            )
                        )
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .inset(by: 0.5)
                                .stroke(
                                    Color(red: 0.84, green: 0.84, blue: 0.84),
                                    lineWidth: 1)

                        )
                    }
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 191)

                }
                .frame(maxWidth: .infinity)

                .padding(.horizontal, 20)
                .padding(.top, 26)

            }
            .ignoresSafeArea()
        }
    }
}


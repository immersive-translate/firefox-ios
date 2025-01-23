// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct YearProSubscriptionHeaderSwiftUIView: View {
    let info: ProSubscriptionInfo
    
    var getYearMonthPriceString: String {
        IMSIAPAppleService.formatPrice(product: info.appleProduct, price: info.appleProduct.price / 12)
    }
    
    var getYearCurrentPriceString: String {
        IMSIAPAppleService.formatPrice(product: info.appleProduct)
    }
    
    var getYearOriginPriceString: String {
    
        let discoutRate = info.serverProduct.discountRate
        let currentPrice = info.appleProduct.price
        let discountDecimal = Decimal(floatLiteral: discoutRate)
        let originPrice = if discoutRate > 0 {
            currentPrice / discountDecimal
            
        } else {
            currentPrice
        }
        return IMSIAPAppleService.formatPrice(product: info.appleProduct, price: originPrice)
    }
    
    var getSavedMoneyString: String {
        let discoutRate = info.serverProduct.discountRate
        let currentPrice = info.appleProduct.price
        
        // 计算原价
        let discountDecimal = Decimal(floatLiteral: discoutRate)
        let originPrice = if discoutRate > 0 {
            currentPrice / discountDecimal
        } else {
            currentPrice
        }
        
        // 计算节省的金额
        let savedMoney = originPrice - currentPrice
        
        // 格式化节省的金额
        return IMSIAPAppleService.formatPrice(product: info.appleProduct, price: savedMoney)
    }

    
    
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
                                        red: 1, green: 0.57,
                                        blue: 0.52
                                    ).opacity(0.4),
                                    location: 0.00),
                                Gradient.Stop(
                                    color: Color(
                                        red: 1, green: 0.68,
                                        blue: 0.52
                                    ).opacity(0), location: 0.67
                                ),
                            ],
                            startPoint: UnitPoint(
                                x: 0.41, y: 0),
                            endPoint: UnitPoint(x: 0.3, y: 1)
                        )
                    )
                
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                        HStack {
                            Image("iap_year_discount_alerm")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("限时特惠")
                                .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                                .foregroundColor(
                                    Color(red: 1, green: 0.78, blue: 0.21))
                            Spacer()
                        }
                        .padding(.leading, 24)
                        .padding(.bottom, 10)
                    }
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(
                                    color: Color(
                                        red: 0.13, green: 0.13, blue: 0.13),
                                    location: 0.00),
                                Gradient.Stop(
                                    color: Color(
                                        red: 0.41, green: 0.41, blue: 0.41),
                                    location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.31, y: 1.08),
                            endPoint: UnitPoint(x: 0.92, y: 0)
                        )
                    )
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                    .offset(y: 191 - 64 + 44)
                    
                    ZStack(alignment: .bottom) {
                        VStack {
                            HStack {
                                Text("年费Pro会员")
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
                                Text(getYearMonthPriceString)
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
                            
                            HStack {
                                Text("\(getYearCurrentPriceString)/年")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 16)
                                    )
                                    .foregroundColor(
                                        Color(red: 0.2, green: 0.2, blue: 0.2))
                                Text("\(getYearOriginPriceString)/年")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 16)
                                    )
                                    .strikethrough()
                                    .foregroundColor(
                                        Color(red: 0.6, green: 0.6, blue: 0.6))
                                Spacer()
                            }
                            .padding(.leading, 24)
                            .padding(.top, 8)
                            .padding(.bottom, 20)
                            
                        }
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 191)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(
                                        color: .white, location: 0.39),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 1, green: 0.82, blue: 0.84),
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
                        if info.serverProduct.discountRate > 0 {
                            HStack {
                                Spacer()
                                
                                HStack {
                                    Text("🔥立省\(getSavedMoneyString)")
                                        .font(
                                            Font.custom(
                                                "Alibaba PuHuiTi 3.0", size: 14)
                                        )
                                        .foregroundColor(
                                            Color(
                                                red: 0.92, green: 0.3,
                                                blue: 0.54))
                                }
                                .foregroundColor(.clear)
                                .frame(height: 30)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 5)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(
                                                color: Color(
                                                    red: 0.92, green: 0.3,
                                                    blue: 0.54
                                                ).opacity(0.15), location: 0.00),
                                            Gradient.Stop(
                                                color: Color(
                                                    red: 0.92, green: 0.3,
                                                    blue: 0.54
                                                ).opacity(0.04), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 1, y: 0),
                                        endPoint: UnitPoint(x: 0, y: 1)
                                    )
                                )
                                .cornerRadius(24, corners: [.topLeft, .bottomRight])
                                
                            }
                        }
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


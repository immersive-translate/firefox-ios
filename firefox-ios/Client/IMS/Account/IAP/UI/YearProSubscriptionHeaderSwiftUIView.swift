// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct YearProSubscriptionHeaderSwiftUIView: View {
    let info: ProSubscriptionInfo
    let fromSource: ProSubscriptionFromSource
    
    var getYearMonthPriceString: String {
        IMSIAPAppleService.formatPrice(product: info.appleProduct, price: info.appleProduct.price / 12)
    }
    
    var getYearCurrentPriceString: String {
        IMSIAPAppleService.formatPrice(product: info.appleProduct)
    }
    
    var getYearOriginPriceString: String {
        let discoutRate = 1 - info.serverProduct.discountRate
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
        let discoutRate = 1 - info.serverProduct.discountRate
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
                if fromSource == .upgrade {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 241)
                        .background(
                            Image("iap_year_bg")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        )
                }
                
                ZStack(alignment: .top) {
                    VStack {
                        Spacer()
                        HStack(spacing: 0) {
                            Image("iap_year_discount_alerm")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Spacer().frame(width: 12)
                            Text("\(String.IMS.IAP.limitedTimeOffer)")
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
                            endPoint: UnitPoint(x: 0.92, y: 0))
                    )
                    .cornerRadius(24, corners: [.bottomLeft, .bottomRight])
                    .offset(y: 201 - 64 + 44)
                    
                    ZStack(alignment: .bottom) {
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: 24)
                            
                            HStack(spacing: 0) {
                                Spacer().frame(width: 24)
                                Text("\(String.IMS.IAP.yearPro)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(
                                        Color(red: 0.2, green: 0.2, blue: 0.2))
                                
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
                                Text(getYearCurrentPriceString)
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 48)
                                    )
                                    .multilineTextAlignment(.trailing)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Text("/\(String.IMS.IAP.year)")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 24)
                                    )
                                    .foregroundColor(
                                        Color(red: 0.92, green: 0.3, blue: 0.54)
                                    )
                                Spacer().frame(width: 10)
                                
                                Text("\(getYearMonthPriceString)/\(String.IMS.IAP.month)")
                                    .font(Font.custom("PingFang SC", size: 16))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .lastTextBaseline, spacing: 0) {
                                Spacer().frame(width: 24)
                                
                                Text("\(getYearOriginPriceString)/\(String.IMS.IAP.year)")
                                    .font(
                                        Font.custom(
                                            "Alibaba PuHuiTi 3.0", size: 16)
                                    )
                                    .strikethrough()
                                    .foregroundColor(
                                        Color(red: 0.6, green: 0.6, blue: 0.6))
                                Spacer()
                            }
                            
                            Spacer()
                                .frame(height: 30)
                        }
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity)
                        .frame(height: 201)
                        .background(
                            Image("iap_year_header_bg")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        )
                        .cornerRadius(24)

                        if info.serverProduct.discountRate > 0 {
                            HStack {
                                Spacer()
                                
                                HStack {
                                    Text("🔥\(String.IMS.IAP.save)\(getSavedMoneyString)")
                                        .font(
                                            Font.custom(
                                                "Alibaba PuHuiTi 3.0", size: 14)
                                        )
                                        .foregroundColor(
                                            Color(red: 0.92, green: 0.3, blue: 0.54))
                                }
                                .foregroundColor(.clear)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 5)
                                .frame(height: 30)
                                .background(
                                    Image("iap_year_hot_icon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .clipped()
                                )
                                .cornerRadius(24, corners: [.topLeft, .bottomRight])
                            }
                        }
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

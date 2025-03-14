import Combine
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import SwiftUI
import StoreKit
import Shared
import Common

struct ProSubscriptionSwiftUIView: View {
    @ObservedObject var viewModel: ProSubscriptionViewModel

    init(viewModel: ProSubscriptionViewModel) {
        self.viewModel = viewModel
    }

    var getDiscountPercentString: String {
        guard
            let info = viewModel.infos.first(where: {
                $0.serverProduct.goodType == .yearly
            })
        else {
            return ""
        }
        let discountRate = info.serverProduct.discountRate
        // 将折扣率转换为百分比并四舍五入到整数
        let percentValue = Int(round(discountRate * 100))
        return "（\(String.IMS.IAP.save)\(percentValue)% ）"
    }
    
    func getUpgradeSavePercentString(monthProduct: StoreKit.Product, yearProduct: StoreKit.Product) -> String {
        let rate = (monthProduct.price - yearProduct.price / 12.0) / monthProduct.price
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent  // 设置为百分比格式
        formatter.minimumFractionDigits = 0  // 最小小数位数
        formatter.maximumFractionDigits = 0  // 最大小数位数
        if let result = formatter.string(from: rate as NSNumber) {
            return result
        }
        return ""
    }
    
    func getYearCurrentPriceString(yearProduct: StoreKit.Product) -> String {
        return IMSIAPAppleService.formatPrice(product: yearProduct)
    }
    
    func getYearEndTimeString() -> String {
        let currentDate = Date()
        if let futureDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedDate = formatter.string(from: futureDate)
            return formattedDate
        }
        return ""
    }
    
    var backgroundColor: Color {
        let themeManager: ThemeManager = AppContainer.shared.resolve()
        if viewModel.fromSource == .onboarding {
            return Color(uiColor: themeManager.getCurrentTheme(for: nil).colors.layer2)
        } else {
            return Color.clear
        }
    }

    var body: some View {
        VStack {
            if viewModel.infos.isEmpty {
                EmptyView()
            } else {
                ZStack {
                    subscriptionView
                    if viewModel.showUpgradeAlert {
                        upgradeMessageView
                    }
                    messageAlertView
                }
            }
        }
        .background(
            Color.clear
        )
        .onAppear {
            viewModel.fetchProductInfos()
        }
    }

    var messageAlertView: some View {
        switch viewModel.messageType {
        case .none:
            AnyView(EmptyView())
        case .title(let string):
            AnyView(
                VStack {
                    VStack(spacing: 0) {
                        Text("\(string)")
                            .font(
                                Font.custom("PingFang SC", size: 17)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black.opacity(0.9))
                            .padding(.top, 42)
                            .padding(.bottom, 34.5)

                        Divider()
                        Button {
                            viewModel.messageType = .none
                        } label: {
                            Text("\(String.IMS.IAP.confirm)")
                                .font(
                                    Font.custom("PingFang SC", size: 17)
                                        .weight(.medium)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black.opacity(0.9))
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)

                    }
                    .background(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 27)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(.black.opacity(0.5))
            )
        }
    }
    
    
    func theAnnualPlanSavesView(monthProduct: StoreKit.Product, yearProduct: StoreKit.Product) -> some View {
        let format = String.IMS.IAP.theAnnualPlanSaves
        
        let percentageText = getUpgradeSavePercentString(monthProduct: monthProduct, yearProduct: yearProduct)
        
        let fullText = String(format: format, percentageText)
        var attributedString = AttributedString(fullText)
        attributedString.foregroundColor = .black
        attributedString.font = Font.custom("Alibaba PuHuiTi 3.0", size: 14)
        
        if let range = attributedString.range(of: percentageText) {
            attributedString[range].foregroundColor = Color(red: 0.92, green: 0.3, blue: 0.54)
            attributedString[range].font = .system(size: 24, weight: .bold)
        }
        
        return Text(attributedString)
    }
    
    func upgradingNowWillAutomaticallyDeduct(monthProduct: StoreKit.Product, yearProduct: StoreKit.Product) -> some View {
        let format = String.IMS.IAP.upgradingNowWillAutomaticallyDeduct
        
        let percentageText = getYearCurrentPriceString(yearProduct: yearProduct)
        
        let fullText = String(format: format, percentageText)
        var attributedString = AttributedString(fullText)
        attributedString.foregroundColor = .black
        attributedString.font = Font.custom("Alibaba PuHuiTi 3.0", size: 14)
        
        if let range = attributedString.range(of: percentageText) {
            attributedString[range].foregroundColor = Color(red: 0.92, green: 0.3, blue: 0.54)
            attributedString[range].font = Font.custom("Alibaba PuHuiTi 3.0", size: 14)
        }
        
        return Text(attributedString)
    }
    
    
    var upgradeMessageView: some View {
        if let monthProduct = viewModel.infos.first(where: { $0.serverProduct.goodType == .monthly })?.appleProduct,
           let yearProduct = viewModel.infos.first(where: { $0.serverProduct.goodType == .yearly })?.appleProduct {
            AnyView(
                VStack {
                    ZStack(alignment: .topTrailing) {
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(String.IMS.IAP.upgradetoAnnualProMembership)")
                                    .font(
                                        Font.custom("Alibaba PuHuiTi 3.0", size: 18)
                                    )
                                    .foregroundColor(
                                        Color(red: 0.2, green: 0.2, blue: 0.2))
                                
                                Spacer()
                            }
                            Spacer().frame(height: 29)
                            
                            HStack(spacing: 0) {
                                theAnnualPlanSavesView(monthProduct: monthProduct, yearProduct: yearProduct)

                                Spacer()
                            }
                            
                            Spacer().frame(height: 21)
                            
                            HStack(spacing: 0) {
                                upgradingNowWillAutomaticallyDeduct(monthProduct: monthProduct, yearProduct: yearProduct)

                                Spacer()
                            }
                            
                            Spacer().frame(height: 32)
                            
                            Button {
                                viewModel.purchaseProduct()
                            } label: {
                                HStack {
                                    Image("iap_upgrade_bt_icon")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("\(String.IMS.IAP.upgradeNow)")
                                        .font(
                                            Font.custom(
                                                "Alibaba PuHuiTi 3.0", size: 16)
                                        )
                                        .foregroundColor(
                                            Color(red: 1, green: 0.78, blue: 0.21))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(
                                                color: Color(
                                                    red: 0.13, green: 0.13,
                                                    blue: 0.13), location: 0.00),
                                            Gradient.Stop(
                                                color: Color(
                                                    red: 0.41, green: 0.41,
                                                    blue: 0.41), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.31, y: 1.08),
                                        endPoint: UnitPoint(x: 0.92, y: 0)
                                    )
                                )
                                
                                .cornerRadius(8)
                                .padding(.horizontal, 9)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            Button {
                                viewModel.showUpgradeAlert = false
                            } label: {
                                HStack {
                                    Text("\(String.IMS.IAP.Cancel)")
                                        .font(
                                            Font.custom(
                                                "Alibaba PuHuiTi 3.0", size: 16)
                                        )
                                        .foregroundColor(
                                            Color(red: 0.6, green: 0.6, blue: 0.6))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .cornerRadius(8)
                                .padding(.horizontal, 9)
                            }
                            
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(8)
                        
                        Button {
                            viewModel.showUpgradeAlert = false
                        } label: {
                            HStack {
                                Image("iap_upgrade_alert_close_icon")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                        }
                        .frame(width: 40, height: 40)
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                        
                    }
                }
                    .padding(.horizontal, 27)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(.black.opacity(0.5))
            )
        } else {
            AnyView(EmptyView())
        }
    }

    var subscriptionView: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                TabView(selection: $viewModel.selectedConfiGoodType) {
                    ForEach(viewModel.infos) { info in
                        switch info.serverProduct.goodType {
                        case .monthly:
                            MonthProSubscriptionSwiftUIView(info: info, fromSource: viewModel.fromSource)
                                .frame(width: geo.size.width)
                                .frame(height: geo.size.height)
                                .tag(IMSResponseConfiGoodType.monthly)
                        case .yearly:
                            YearProSubscriptionSwiftUIView(info: info, fromSource: viewModel.fromSource)
                                .frame(width: geo.size.width)
                                .frame(height: geo.size.height)
                                .tag(IMSResponseConfiGoodType.yearly)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))  // 设置分页样式
                .background(Color.clear)

            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)

            // 底部固定的内容
            VStack(spacing: 0) {
                Divider()
                Spacer()
                    .frame(height: 17)

                GeometryReader { geo in
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: 4)

                        Button {
                            withAnimation {
                                viewModel.selectedConfiGoodType = .yearly
                            }
                        } label: {
                            Text(
                                "\(String.IMS.IAP.consecutiveAnnualSubscription)\(getDiscountPercentString)"
                            )
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(
                                viewModel.selectedConfiGoodType == .yearly
                                ? Color(uiColor: UIColor(hexString: "#FFFFFF").withDarkColor("#000000")) : Color(uiColor: UIColor(hexString: "#000000").withDarkColor("#FFFFFF")))
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (216.0 / 335.0))
                        .frame(height: 40)
                        .background(
                            viewModel.selectedConfiGoodType == .yearly
                            ? Color(uiColor: UIColor(hexString: "#EA4C89").withDarkColor("#E23C7C"))
                                : .clear
                        )
                        .cornerRadius(28)

                        Button {
                            withAnimation {
                                viewModel.selectedConfiGoodType = .monthly
                            }
                        } label: {
                            Text(
                                "\(String.IMS.IAP.consecutiveMonthlySubscription)"
                            )
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(
                                viewModel.selectedConfiGoodType == .monthly
                                ? Color(uiColor: UIColor(hexString: "#FFFFFF").withDarkColor("#000000")) : Color(uiColor: UIColor(hexString: "#000000").withDarkColor("#FFFFFF")))
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (111.0 / 335.0))
                        .frame(height: 40)
                        .background(
                            viewModel.selectedConfiGoodType == .monthly
                                ? Color(uiColor: UIColor(hexString: "#EA4C89").withDarkColor("#E23C7C"))
                                : .clear
                        )
                        .cornerRadius(28)

                        Spacer()
                            .frame(width: 4)
                    }
                    .frame(maxHeight: .infinity)
                }
                .foregroundColor(.clear)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(.clear)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .inset(by: -0.5)
                        .stroke(
                            Color(uiColor: UIColor(hexString: "#ECF0F7").withDarkColor("#666666")),
                            lineWidth: 1)

                )
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 20)

                ProSubscriptionButton(viewModel: viewModel)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                if viewModel.fromSource == .onboarding {
                    Spacer().frame(height: 8)
                    
                    Button {
                        self.viewModel.coordinator?.handleNotNeedNow()
                    } label: {
                        Text("\(String.IMS.IAP.notNeedNow)")
                            .font(Font.custom("PingFang SC", size: 14))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(uiColor: UIColor(hexString: "#333333").withDarkColor("#D8D8D8")))
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }

                Spacer().frame(height: 8)
                
                ProSubscritionBottom(viewModel: viewModel)
                Spacer().frame(height: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ProSubscriptionSwiftUIView(viewModel: .init())
}

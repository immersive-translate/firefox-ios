import Combine
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import SwiftUI

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

    var body: some View {
        VStack {
            if viewModel.infos.isEmpty {
                EmptyView()
            } else {
                ZStack {
                    subscriptionView
                    messageAlertView
                }
            }
        }
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

    var subscriptionView: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                TabView(selection: $viewModel.selectedConfiGoodType) {
                    ForEach(viewModel.infos) { info in
                        switch info.serverProduct.goodType {
                        case .monthly:
                            MonthProSubscriptionSwiftUIView(info: info)
                                .frame(width: geo.size.width)
                                .frame(height: geo.size.height)
                                .tag(IMSResponseConfiGoodType.monthly)
                        case .yearly:
                            YearProSubscriptionSwiftUIView(info: info)
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
                                    ? .white : .black)
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (216.0 / 335.0))
                        .frame(height: 40)
                        .background(
                            viewModel.selectedConfiGoodType == .yearly
                                ? Color(red: 0.92, green: 0.3, blue: 0.54)
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
                                    ? .white : .black)
                        }
                        .foregroundColor(.clear)
                        .frame(width: geo.size.width * (111.0 / 335.0))
                        .frame(height: 40)
                        .background(
                            viewModel.selectedConfiGoodType == .monthly
                                ? Color(red: 0.92, green: 0.3, blue: 0.54)
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
                .background(.white)

                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .inset(by: -0.5)
                        .stroke(
                            Color(red: 0.93, green: 0.95, blue: 0.96),
                            lineWidth: 1)

                )
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 20)

                Button {
                    viewModel.purchaseProduct()
                } label: {
                    Text("\(String.IMS.IAP.subscribeNow)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 1, green: 0.78, blue: 0.21))
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
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
                .cornerRadius(12)
                .padding(.horizontal, 20)

            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ProSubscriptionSwiftUIView(viewModel: .init(token: ""))
}

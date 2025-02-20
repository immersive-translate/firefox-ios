// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

struct ProSubscriptionButton: View {
    @ObservedObject var viewModel: ProSubscriptionViewModel
    
    var disableButtonBgView: some View {
        AnyView(
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: Color.clear, location: 0.00),
                    Gradient.Stop(
                        color: Color.clear, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.31, y: 1.08),
                endPoint: UnitPoint(x: 0.92, y: 0)
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(
                    Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
            )
    }
    
    var enableButtonBgView: some View {
        AnyView(
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(
                    Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
            
        )
    }
    
    var body: some View {
        if viewModel.userInfo?.iosPlanTier != "upgrade" {
            // 试用
            Button {
                viewModel.purchaseProduct()
            } label: {
                Text("\(String.IMS.IAP.free3day)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(
                        Color(red: 1, green: 0.78, blue: 0.21)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(enableButtonBgView)
            
        } else {
            if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .monthly {
                /// 当前月付，选择月付
                Button {
                    
                } label: {
                    Text("\(String.IMS.IAP.currentPlan)")
                        .font(
                            Font.custom("Alibaba PuHuiTi 3.0", size: 16)
                        )
                        .foregroundColor(
                            Color(red: 0.6, green: 0.6, blue: 0.6))
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(disableButtonBgView)
                
            } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .yearly {
                /// 当前年付，选择年付
                Button {
                    
                } label: {
                    Text("\(String.IMS.IAP.currentPlan)")
                        .font(
                            Font.custom("Alibaba PuHuiTi 3.0", size: 16)
                        )
                        .foregroundColor(
                            Color(red: 0.6, green: 0.6, blue: 0.6))
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(disableButtonBgView)
            } else if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .yearly {
                /// 当前月付，选择年付
                if viewModel.userInfo?.subscription?.paymentChannel == "stripe" {
                    // stripe
                    Button {
                        
                    } label: {
                        Text("\(String.IMS.IAP.upgradeToPc)")
                            .font(
                                Font.custom("Alibaba PuHuiTi 3.0", size: 16)
                            )
                            .foregroundColor(
                                Color(red: 0.6, green: 0.6, blue: 0.6))
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(disableButtonBgView)
                } else {
                    Button {
                        viewModel.showUpgradeAlert = true
                    } label: {
                        HStack {
                            Image("iap_upgrade_bt_icon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text("\(String.IMS.Settings.Upgrade)")
                                .font(
                                    Font.custom(
                                        "Alibaba PuHuiTi 3.0", size: 16)
                                )
                                .foregroundColor(
                                    Color(red: 1, green: 0.78, blue: 0.21))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                    }
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(enableButtonBgView)
                }
            } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .monthly {
                /// 当前年付，选择月付
                Button {
                    
                } label: {
                    Text("\(String.IMS.IAP.downgradingIsNotSupported)")
                      .font(Font.custom("Alibaba PuHuiTi 3.0", size: 16))
                      .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                      .frame(maxWidth: .infinity)
                      .frame(maxHeight: .infinity)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(disableButtonBgView)
            } else {
                /// 其他
                Button {
                    viewModel.purchaseProduct()
                } label: {
                    Text("\(String.IMS.IAP.subscribeNow)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(
                            Color(red: 1, green: 0.78, blue: 0.21)
                        )
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(enableButtonBgView)
            }
            
        }
    }
}

#Preview {
    ProSubscriptionSwiftUIView(viewModel: .init())
}

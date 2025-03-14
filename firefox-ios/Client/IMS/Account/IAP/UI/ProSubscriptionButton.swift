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
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .inset(by: 0.5)
//                .stroke(
//                    Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
//            )
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
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .inset(by: 0.5)
//                .stroke(
//                    Color(red: 0.6, green: 0.6, blue: 0.6), lineWidth: 1)
//            
//        )
    }
    
    var upgradeToPc: some View {
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
    }
    
    var free3day: some View {
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
    }
    
    var currentPlan: some View {
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
    }
    
    var upgrade: some View {
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
    
    var downgradingIsNotSupported: some View {
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
    }
    
    var subscribeNow: some View {
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
    
    var body: some View {
        if viewModel.userInfo?.subscription?.paymentChannel == "stripe" {
            // stripe
            if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .monthly {
                /// 当前月付，选择月付
                currentPlan
                
            } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .yearly {
                /// 当前年付，选择年付
                currentPlan
            } else if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .yearly {
                /// 当前月付，选择年付
                upgradeToPc
            } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .monthly {
                /// 当前年付，选择月付
                downgradingIsNotSupported
            } else {
                /// 其他
                upgradeToPc
            }
        } else {
            if viewModel.userInfo?.iosPlanTier != "upgrade" {
                // 试用
                free3day
                
            } else {
                if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .monthly {
                    /// 当前月付，选择月付
                    currentPlan
                    
                } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .yearly {
                    /// 当前年付，选择年付
                    currentPlan
                } else if viewModel.userInfo?.subscription?.subscriptionType == .monthly, viewModel.selectedConfiGoodType == .yearly {
                    /// 当前月付，选择年付
                    upgrade
                } else if viewModel.userInfo?.subscription?.subscriptionType == .yearly, viewModel.selectedConfiGoodType == .monthly {
                    /// 当前年付，选择月付
                    downgradingIsNotSupported
                } else {
                    /// 其他
                    subscribeNow
                }
                
            }
        }
        
    }
}

#Preview {
    ProSubscriptionSwiftUIView(viewModel: .init())
}

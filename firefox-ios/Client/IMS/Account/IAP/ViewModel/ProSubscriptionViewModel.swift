// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import StoreKit
import SVProgressHUD
import Adjust

struct ProSubscriptionInfo: Identifiable {
    let id = UUID()
    let serverProduct: IMSResponseConfiGood
    let appleProduct: StoreKit.Product
}

enum ProSubscriptionMessageType {
    case none
    case title(String)
}

protocol ProSubscriptionDelegate: AnyObject {
    func showLoginModalWebView()
    func showPurchaseSuccess()
    func handleNotNeedNow()
    func showTerms()
    func showPrivacy()
}


enum ProSubscriptionFromSource {
    case upgrade
    case onboarding
}

class ProSubscriptionViewModel: ObservableObject {
    
    weak var coordinator: ProSubscriptionDelegate?
    
    let fromSource: ProSubscriptionFromSource
    
    @Published
    var infos: [ProSubscriptionInfo] = []
    
    @Published
    var userInfo: IMSAccountInfo?
    
    @Published
    var selectedConfiGoodType: IMSResponseConfiGoodType = .yearly
    
    @Published
    var messageType: ProSubscriptionMessageType = .none
    
    @Published
    var showUpgradeAlert: Bool = false
    
    init(fromSource: ProSubscriptionFromSource = .upgrade) {
        self.fromSource = fromSource
    }
    
    deinit {
        Task {
            await MainActor.run {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @MainActor
    func fetchProductInfos() {
        SVProgressHUD.show()
        Task {
            do {
                let localUserInfo = IMSAccountManager.shard.current()
                async let configAsync = IMSIAPHttpService.getConfig()
                async let userInfoAsync = IMSIAPHttpService.getUserInfo(token: localUserInfo?.token)
                let (config, userInfo) = try await (configAsync, userInfoAsync)
                guard let channel = config.data.data.first else {
                    throw SKError(.clientInvalid)
                }
                let products = try await IMSAccountManager.shard.iap.getProducts(channel.goods.map{$0.appStoreId})
                guard !products.isEmpty, products.count == channel.goods.count else {
                    throw SKError(.clientInvalid)
                }
                let infos: [ProSubscriptionInfo] = channel.goods.compactMap { good in
                    if let product = products.first(where: { $0.id == good.appStoreId }) {
                        return ProSubscriptionInfo(serverProduct: good, appleProduct: product)
                    }
                    return nil
                }.sorted { item1, item2 in
                    if item1.serverProduct.goodType == .yearly {
                        return true
                    }
                    return false
                }
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    self.infos = infos
                    if let userInfo = userInfo, let token = localUserInfo?.token {
                        
                        self.userInfo = IMSAccountInfo.from(token: token, resp: userInfo.data)
                    } else {
                        self.userInfo = nil
                    }
                    
                }
            } catch {
                print("fetchProductInfo: \(error)")
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "Data Fetch Error")
                }
            }
        }
    }
    
    func showTerms() {
        coordinator?.showTerms()
    }
    
    func showPrivacy() {
        coordinator?.showPrivacy()
    }
    
    func restorePurchases() {
        guard let token = userInfo?.token else {
            coordinator?.showLoginModalWebView()
            return
        }
        SVProgressHUD.show()
        Task {
            do {
                try await IMSAccountManager.shard.iap.restorePurchases()
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    self.coordinator?.showPurchaseSuccess()
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    self.messageType = .title(error.localizedDescription)
                }
            }
        }
    }
    
    
    @MainActor
    func purchaseProduct() {
        guard let info = infos.first(where: { $0.serverProduct.goodType == self.selectedConfiGoodType }) else {
            self.messageType = .title("\(String.IMS.IAP.subscriptionFail)!")
            return
        }
        guard let token = userInfo?.token else {
            coordinator?.showLoginModalWebView()
            return
        }
        SVProgressHUD.show()
        Task {
            do {
                let priceId = info.serverProduct.appStoreId
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = .current
                let currencyCode = formatter.currencyCode.lowercased()
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                
                let req = IMSHttpOrderRequest(priceId: priceId, currency: currencyCode, startTrial: false, successUrl: "", cancelUrl: "", locale: "", coupon: "", referral: "", quantity: 1, targetLanguage: "", deviceId: "", platform: "", abField: "", appVersion: appVersion, browser: "", browserUserAgent: "", utmCampaign: "", utmMedium: "", utmSource: "", installTime: "2024-12-24T12:42:45.021Z", installChannel: "", interfaceLang: "", lastLoginTime: "2024-12-24T12:42:45.021Z", lastLoginIP: "", userCreateTime: "2024-12-24T12:42:45.021Z", extendData: "", returnUrl: "", actName: "", payTips: "")
                let ret: IMSHttpResponse<IMSResponseOrder> = try await IMSIAPHttpService.getOrder(token: token, data: req)
                let outTradeNo = ret.data.imtSession.outTradeNo
                try await IMSAccountManager.shard.iap.purchase(productId: priceId, orderNo: outTradeNo)
                await MainActor.run {
                    SVProgressHUD.dismiss()
//                    self.trackPurchaseEvent(info: info)
                    self.coordinator?.showPurchaseSuccess()
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    switch info.serverProduct.goodType {
                    case .monthly:
                        self.messageType = .title("\(String.IMS.IAP.subscriptionFail)\n\(String.IMS.IAP.monthlyProMembership)!")
                    case .yearly:
                        self.messageType = .title("\(String.IMS.IAP.subscriptionFail)\n\(String.IMS.IAP.yearPro)!")
                    }
                }
            }
        }
    }
    
    func trackPurchaseEvent(info: ProSubscriptionInfo) {
        let event = ADJEvent(eventToken: "8ae2y6")
        let amount = (info.appleProduct.price as NSDecimalNumber).doubleValue
        let currencyCode = info.appleProduct.priceFormatStyle.currencyCode
        event?.setRevenue(amount, currency: currencyCode)
        let payType = if userInfo?.iosPlanTier == "trial" {
            "1"
        } else {
            if info.serverProduct.goodType == .monthly {
                "2"
            } else if info.serverProduct.goodType == .yearly {
                if userInfo?.subscription?.subscriptionType == .monthly {
                    "4"
                } else {
                    "3"
                }
            } else {
                "0"
            }
        }
        event?.addPartnerParameter("pay_type", value: payType)
        event?.addPartnerParameter("user_id", value: "\(userInfo?.uid ?? 1)")
        Adjust.trackEvent(event)
        
    }
}

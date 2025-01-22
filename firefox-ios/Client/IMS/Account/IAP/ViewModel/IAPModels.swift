// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


// 请求参数模型
struct IMSHttpOrderRequest: Codable {
    let priceId: String
    let currency: String
    let startTrial: Bool
    let successUrl: String
    let cancelUrl: String
    let locale: String
    let coupon: String
    let referral: String
    let quantity: Int
    let targetLanguage: String
    let deviceId: String
    let platform: String
    let abField: String
    let appVersion: String
    let browser: String
    let browserUserAgent: String
    let utmCampaign: String
    let utmMedium: String
    let utmSource: String
    let installTime: String
    let installChannel: String
    let interfaceLang: String
    let lastLoginTime: String
    let lastLoginIP: String
    let userCreateTime: String
    let extendData: String
    let returnUrl: String
    let actName: String
    let payTips: String
}

// 响应模型
struct IMSHttpResponse<Data: Codable>: Codable {
    let code: Int
    let data: Data
}

struct IMSResponseOrder: Codable {
    let imtSessionId: Int
    let imtSession: IMSResponseOrderSession
    let redirect: String
    let clientSecret: String?
    let prePayId: String?
    let jsApiUiPackage: String?
}

struct IMSResponseOrderSession: Codable {
    let userId: Int
    let userEmail: String
    let subscriptionGoodsID: Int
    let priceID: String
    let quantity: Int
    let subscriptionDay: Int
    let subscriptionType: String
    let subscriptionGoodsSnap: String
    let orderStatus: String
    let subscriptionId: String?
    let invoiceId: String?
    let checkoutSessionId: String
    let checkoutSessionStatus: String?
    let orderType: String
    let productName: String?
    let amount: Double
    let payTime: String?
    let outTradeNo: String
    let amountPaid: Double?
    let operator_: String?
    let updateTime: String
    let createTime: String
    let isDeleted: Bool
    let dataVersion: Int
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case userId, userEmail, subscriptionGoodsID, priceID, quantity
        case subscriptionDay, subscriptionType, subscriptionGoodsSnap
        case orderStatus, subscriptionId, invoiceId, checkoutSessionId
        case checkoutSessionStatus, orderType, productName, amount
        case payTime, outTradeNo, amountPaid
        case operator_ = "operator"
        case updateTime, createTime, isDeleted, dataVersion, id
    }
}

struct IMSResponseConfigData: Codable {
    let data: [IMSResponseConfigChannel]
}

// 渠道信息
struct IMSResponseConfigChannel: Codable {
    let channelName: String
    let channelIco: String
    let channelCode: String
    let symbol: String
    let goods: [IMSResponseConfiGood]
}

// 商品信息
struct IMSResponseConfiGood: Codable {
    let channelCode: String
    let appStoreId: String
    let currency: String
    let notice: String
    let isShowNotice: Bool
    let amount: String
    let actualAmount: String
    let goodName: String
    let goodType: IMSResponseConfiGoodType
    let discountRate: Double
}

enum IMSResponseConfiGoodType: String, Codable {
    case monthly = "monthly"
    case yearly = "yearly"
}

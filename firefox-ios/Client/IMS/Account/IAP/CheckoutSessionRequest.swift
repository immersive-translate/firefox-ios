// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import Foundation

// 请求参数模型
struct CheckoutSessionRequest: Codable {
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
struct CheckoutSessionResponse: Codable {
    let code: Int
    let data: SessionData
}

struct SessionData: Codable {
    let imtSessionId: Int
    let imtSession: IMTSession
    let redirect: String
    let clientSecret: String?
    let prePayId: String?
    let jsApiUiPackage: String?
}

struct IMTSession: Codable {
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

// 网络请求错误枚举
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
}

// 支付管理类
class PaymentManager {
    // 配置
    private struct Config {
        static let baseURL = "https://test-api2.immersivetranslate.com"
        static let checkoutPath = "/v1/user/ios-pay-checkout-sessions"
    }
    
    private let session: URLSession
    private let token: String
    
    init(token: String) {
        self.token = token
        self.session = URLSession.shared
    }
    
    // 创建结账会话
    func createCheckoutSession(request: CheckoutSessionRequest) async throws -> CheckoutSessionResponse {
        guard let url = URL(string: Config.baseURL + Config.checkoutPath) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // 设置请求头
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        urlRequest.setValue("zh-CN,zh;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.setValue(token, forHTTPHeaderField: "token")
        
        // 设置请求体
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(CheckoutSessionResponse.self, from: data)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

// 使用示例
//func example() async {
//    let request = CheckoutSessionRequest(
//        priceId: "price_1PfcrjGc8iUjvqOFXi9TgSPS",
//        currency: "cny",
//        startTrial: false,
//        successUrl: "",
//        cancelUrl: "",
//        locale: "",
//        coupon: "",
//        referral: "",
//        quantity: 1,
//        targetLanguage: "",
//        deviceId: "",
//        platform: "",
//        abField: "",
//        appVersion: "",
//        browser: "",
//        browserUserAgent: "",
//        utmCampaign: "",
//        utmMedium: "",
//        utmSource: "",
//        installTime: "2024-12-24T12:42:45.021Z",
//        installChannel: "",
//        interfaceLang: "",
//        lastLoginTime: "2024-12-24T12:42:45.021Z",
//        lastLoginIP: "",
//        userCreateTime: "2024-12-24T12:42:45.021Z",
//        extendData: "",
//        returnUrl: "",
//        actName: "",
//        payTips: ""
//    )
//    
//    let paymentManager = PaymentManager(token: "your-token-here")
//    
//    do {
//        let response = try await paymentManager.createCheckoutSession(request: request)
//        print("Session ID: \(response.data.imtSessionId)")
//        print("Checkout Session ID: \(response.data.imtSession.checkoutSessionId)")
//        print("Amount: \(response.data.imtSession.amount)")
//    } catch {
//        print("Error: \(error)")
//    }
//}

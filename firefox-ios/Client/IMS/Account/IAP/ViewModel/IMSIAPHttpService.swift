// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSIAPHttpService {
    // 网络请求错误枚举
    enum NetworkError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case invalidData
    }
    
    // 配置
    private struct Config {
        static let baseURL = "https://test-api2.immersivetranslate.com"
        static let checkoutPath = "/v1/user/ios-pay-checkout-sessions"
        static let configPath = "/v1/payments/ios-pay-config"
    }
     
    
    static func getOrder(token: String, data: IMSHttpOrderRequest) async throws -> IMSHttpResponse<IMSResponseOrder> {
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
        urlRequest.httpBody = try encoder.encode(data)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(IMSHttpResponse<IMSResponseOrder>.self, from: data)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    static func getConfig(token: String) async throws -> IMSHttpResponse<IMSResponseConfigData> {
        guard let url = URL(string: Config.baseURL + Config.configPath) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // 设置请求头
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        urlRequest.setValue("zh-CN,zh;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        urlRequest.setValue(token, forHTTPHeaderField: "token")
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(IMSHttpResponse<IMSResponseConfigData>.self, from: data)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

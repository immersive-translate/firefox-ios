// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

enum UserAccountAPI {
    enum LoginType {
        case email(String, String)
    }
    
    struct WebLoginRequest: IMSAPIRequest {
        typealias DataResponse = LoginResult
        
        var loginType: LoginType
        
        var path: String {
            return "/v1/user-account/web-login"
        }
        
        var method: APIRequestMethod {
            return .post
        }
        
        var parameters: [String: Any]? {
            switch loginType {
            case let .email(userName, password):
                return [
                    "userName": userName,
                    "password": password
                ]
            }
        }
    }
}

extension UserAccountAPI {
    enum OauthCallbackType {
        case google(String)
        case apple(String)
        case facebook(String)
        case weixin(String)
    }
    
    struct WebOauthCallbackRequest: IMSAPIRequest {
        typealias DataResponse = LoginResult
        
        var oauthCallbackType: OauthCallbackType
        
        var path: String {
            return "/v1/user-account/web-oauth-callback"
        }
        
        var parameters: [String: Any]? {
            switch oauthCallbackType {
            case let .google(token):
                return [
                    "state": "Google_imt",
                    "access_token": token
                ]
            case let .apple(token):
                return [
                    "state": "AppleApp_imt",
                    "access_token": token
                ]
            case let .facebook(token):
                return [
                    "state": "Facebook_imt",
                    "access_token": token
                ]
            case let .weixin(code):
                return [
                    "state": "WeChatApp_imt",
                    "code": code
                ]
            }
        }
    }
    
    /// 重置密码发送验证码
    struct FindPasswordCodeRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var email: String
        
        var method: APIRequestMethod {
            return .post
        }
        
        var path: String {
            return "/v1/user-account/find-password-code"
        }
        
        var parameters: [String: Any]? {
            return [
                "email": email
            ]
        }
    }
    
    /// 重置密码发送验证码
    struct ResetPasswordRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var password: String
        var resetCode: String
        var userEmail: String
        
        var method: APIRequestMethod {
            return .post
        }
        
        var path: String {
            return "/v1/user-account/reset-password"
        }
        
        var parameters: [String: Any]? {
            return [
                "password": password,
                "resetCode": resetCode,
                "userEmail": userEmail
            ]
        }
    }
    
    /// 用户注册后输入验证码激活
    struct ActivateRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var activationCode: String
        var email: String
        
        var method: APIRequestMethod {
            return .post
        }
        
        var path: String {
            return "/v1/user-account/activate"
        }
        
        var parameters: [String: Any]? {
            return [
                "email": email,
                "activationCode": activationCode,
            ]
        }
    }
    
    /// 重新发送验证码
    struct ReActivateRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var email: String
        
        var method: APIRequestMethod {
            return .post
        }
        
        var path: String {
            return "/v1/user-account/re-activate"
        }
        
        var parameters: [String: Any]? {
            return [
                "email": email
            ]
        }
    }
    
    /// 注册，发送验证码
    struct RegisterRequest: IMSAPIRequest {
        typealias DataResponse = PlaceholderResponseModel
        
        var email: String
        var password: String
        
        var method: APIRequestMethod {
            return .post
        }
        
        var path: String {
            return "/v1/user-account/register"
        }
        
        var parameters: [String: Any]? {
            return [
                "username": email,
                "email": email,
                "password": password,
                "isDevice": false
            ]
        }
    }
}

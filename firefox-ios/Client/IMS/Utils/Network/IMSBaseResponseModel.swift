// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

enum IMSBaseResponseModelCode: Int {
    /// 成功
    case success = 0
    
    /// 未激活，需要重新发送验证码
    case notActivated = 1001
    /// 未注册
    case notRegistered = 1009
}

public protocol APIModelWrapper {
    associatedtype DataType: Decodable

    var code: Int { get }
    
    var message: String? { get }
    
    var error: String? { get }

    var data: DataType? { get }
}

public struct IMSBaseResponseModel<T>: APIModelWrapper, APIDefaultJSONParsable where T: Decodable {
    public var message: String?
    public var error: String?
    public var code: Int
    public var data: T?
}

public struct PlaceholderResponseModel: Codable {}

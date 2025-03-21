// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

enum IMSBaseResponseModelCode: Int {
    /// 成功
    case success = 0
}

public protocol APIModelWrapper {
    associatedtype DataType: Decodable

    var code: Int { get }
    
    var message: String? { get }

    var data: DataType? { get }
}

public struct IMSBaseResponseModel<T>: APIModelWrapper, APIDefaultJSONParsable where T: Decodable {
    public var message: String?
    public var code: Int
    public var data: T?
}

public struct PlaceholderResponseModel: Codable {}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import APIService


protocol IMSAPIRequest: APIRequest where Response == IMSBaseResponseModel<DataResponse> {
    associatedtype DataResponse: Decodable

    var needToken: Bool { get }

    var needInvalidTokenToast: Bool { get }
}

extension IMSAPIRequest {
    var needToken: Bool {
        return true
    }

    var needInvalidTokenToast: Bool {
        return true
    }

    var baseURL: URL {
        return URL(string: IMSAppUrlConfig.baseAPIURL)!
    }

    var method: APIRequestMethod { .get }

    var parameters: [String: Any]? {
        return nil
    }

    var headers: APIRequestHeaders? {
        return nil
    }

    var taskType: APIRequestTaskType {
        return .request
    }

    var encoding: APIParameterEncoding {
        if method == .get {
            return APIURLEncoding.default
        } else {
            return APIJSONEncoding.default
        }
    }

    public func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var resultURLRequest = urlRequest
        if needToken, let token = IMSAccountManager.shard.current()?.token, token.isNotEmpty {
            resultURLRequest.setValue(token, forHTTPHeaderField: "token")
        }
        for (key, value) in IMSAppUrlConfig.getCommonHeader() {
            resultURLRequest.setValue(value, forHTTPHeaderField: key)
        }
        return resultURLRequest
    }

    public func intercept<U: APIRequest>(request: U, response: APIResponse<Response>, replaceResponseHandler: @escaping APICompletionHandler<Response>) {
        defaultIntercept(request: request, response: response, replaceResponseHandler: replaceResponseHandler)
    }

    public func defaultIntercept<U: APIRequest>(request: U, response: APIResponse<Response>, replaceResponseHandler: @escaping APICompletionHandler<Response>) {
        replaceResponseHandler(response)
    }
}

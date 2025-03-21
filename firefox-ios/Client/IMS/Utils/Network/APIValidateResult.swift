// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import LTXiOSUtils
import APIService

public enum APIValidateResult<T> {
    case success(T)
    case failure(String?, APIError)
}

public enum IMSDataError: Error {
    case invalidParseResponse
}

/// APIModelWrapper 在这个地方用到了
extension APIResult where T: APIModelWrapper {
    var validateResult: APIValidateResult<T.DataType> {
        let message = "Imt.Common.Error.Message".i18nImt()
        switch self {
        case let .success(response):
            if response.code == IMSBaseResponseModelCode.success.rawValue {
                if let data = response.data {
                    return .success(data)
                } else {
                    return .failure(response.error ?? response.message, APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
                }
            } else {
                return .failure(response.error ?? response.message, APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
            }
        case let .failure(apiError):
//            if apiError == APIError.networkError {
//                message = apiError.localizedDescription
//            }
            Log.d(apiError.localizedDescription)
            return .failure(nil, apiError)
        }
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import LTXiOSUtils
import APIService

public enum APIValidateResult<T> {
    case success(T)
    case failure(APIError)
}

public enum IMSDataError: Error {
    case invalidParseResponse
}

/// APIModelWrapper 在这个地方用到了
extension APIResult where T: APIModelWrapper {
    var validateResult: APIValidateResult<T.DataType> {
        let message = "Imt.Common.API.Error.Message".i18nImt()
        switch self {
        case let .success(reponse):
            if reponse.code == IMSBaseResponseModelCode.success.rawValue {
                if let data = reponse.data {
                    return .success(data)
                } else {
                    return .failure( APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
                }
            } else {
                return .failure(APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
            }
        case let .failure(apiError):
//            if apiError == APIError.networkError {
//                message = apiError.localizedDescription
//            }
            Log.d(apiError.localizedDescription)
            return .failure(apiError)
        }
    }
}

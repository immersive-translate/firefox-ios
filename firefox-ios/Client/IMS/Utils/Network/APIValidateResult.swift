// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import LTXiOSUtils
import APIService
import SwiftyJSON

public enum APIValidateResult<T> {
    case success(T)
    case failure(String?, Int?, APIError)
}

public enum APIAllowNullValidateResult<T> {
    case success(T?)
    case failure(String?, Int?, APIError)
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
                    return .failure(response.error ?? response.message, response.code, APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
                }
            } else {
                return .failure(response.error ?? response.message, response.code, APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
            }
        case let .failure(apiError):
            Log.d(apiError.localizedDescription)
            return .failure(message, nil, apiError)
        }
    }
    
    var allowNullValidateResult: APIAllowNullValidateResult<T.DataType> {
        let message = "Imt.Common.Error.Message".i18nImt()
        switch self {
        case let .success(response):
            if response.code == IMSBaseResponseModelCode.success.rawValue {
                return .success(response.data)
            } else {
                return .failure(response.error ?? response.message, response.code, APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
            }
        case let .failure(apiError):
            Log.d(apiError.localizedDescription)
            return .failure(message, nil, apiError)
        }
    }
}

extension APIResponse where T: APIModelWrapper {
    public var validateResult: APIValidateResult<T.DataType> {
        switch result {
        case let .failure(error):
            if let data = data {
                let json = JSON(data)
                let errorStr = json["error"].string
                let message = json["message"].string
                let code = json["code"].int
                return .failure(errorStr ?? message, code, error)
            }
            return result.validateResult
        case .success:
            return result.validateResult
        }
    }
    
    public var allowNullValidateResult: APIAllowNullValidateResult<T.DataType> {
        switch result {
        case let .failure(error):
            if let data = data {
                let json = JSON(data)
                let errorStr = json["error"].string
                let message = json["message"].string
                let code = json["code"].int
                return .failure(errorStr ?? message, code, error)
            }
            return result.allowNullValidateResult
        case .success:
            return result.allowNullValidateResult
        }
    }
}

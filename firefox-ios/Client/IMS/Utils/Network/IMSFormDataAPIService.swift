// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import APIService
import Alamofire
import Swime

extension APIService {
    static func sendFormDataRequest<T: IMSAPIRequest>(_ request: T, completionHandler: APICompletionHandler<T.Response>?) {
        var header = IMSAppUrlConfig.getCommonHeader()
        if request.needToken, let token = IMSAccountManager.shard.current()?.token, token.isNotEmpty {
            header["token"] = token
        }
        guard let urlRequest = try? URLRequest(url: request.completeURL, method: .post, headers: HTTPHeaders(header)) else {
            return
        }
        AF.upload(multipartFormData: { formData in
            if let parameters = request.parameters {
                for item in parameters {
                    if let str = item.value as? String {
                        if let data = str.data(using: .utf8) {
                            formData.append(data, withName: item.key)
                        }
                    } else if let dict = item.value as? [String: Any] {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: dict) {
                            formData.append(jsonData, withName: item.key)
                        }
                    }
                }
            }
            if let file = request.file {
                formData.append(file.data, withName: "File", fileName: file.name, mimeType: Swime.mimeType(data: file.data)?.mime)
            }
        }, with: urlRequest).response { response in
            let apiResult: APIResult<T.Response>
            switch response.result {
            case let .success(data):
                if let tempData = data {
                    do {
                        let responseModel = try T.Response.parse(data: tempData)
                        apiResult = .success(responseModel)
                    } catch {
                        apiResult = .failure(.responseError(error))
                    }
                } else {
                    apiResult = .failure(APIError.responseError(APIResponseError.invalidParseResponse(IMSDataError.invalidParseResponse)))
                }
            case let .failure(error):
                print(error)
                apiResult = .failure(.connectionError(error))
            }

            let apiResponse = APIResponse<T.Response>(request: response.request, response: response.response, data: response.data, result: apiResult)
            completionHandler?(apiResponse)
        }
    }
}

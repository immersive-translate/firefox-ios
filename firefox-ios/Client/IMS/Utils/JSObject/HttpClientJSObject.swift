// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Alamofire

class HttpClientJSObject {
    @objc func request( _ params: [String: String], handler: @escaping (String, Bool)->Void) {
        let url = params["url"]!;
        let method = params["method"]!;
        let data = convertToDictionary(text: params["params"] ?? "");
        var paramDic: [String: Any]?;
        if (data != nil && data!["data"] != nil) {
            paramDic = convertToDictionary(text: data!["data"] as! String);
        }
        var headers: HTTPHeaders?
        if (data != nil && data!["headers"] != nil) {
            headers = HTTPHeaders.init(data!["headers"] as! [String: String])
        }
        
        if (method == "POST") {
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.method = .post
            if (data != nil && data!["data"] != nil) {
                urlRequest.httpBody = (data!["data"] as! String).data(using: .utf8)
            }
            // 用于标记是否已设置Content-Type
            var contentTypeSet = false
            headers?.forEach({ header in
                if header.name.lowercased() == "content-type" {
                    contentTypeSet = true
                }
                urlRequest.headers.add(header);
            })
            if !contentTypeSet {
                urlRequest.headers.add(.contentType("application/json"))
            }
            AF.request(urlRequest).responseString(encoding: .utf8) { response in
                self.deal(forResponse: response, handler:handler)
            }
            return
        }
       
        AF.request(url, method: HTTPMethod(rawValue: method), parameters: paramDic, headers: headers).responseString(encoding: .utf8) { response in
            self.deal(forResponse: response, handler:handler)
        }
    }
    
    func deal(forResponse response:AFDataResponse<String>, handler: @escaping (String, Bool)->Void) {
        let dic:[String: Any] = [
            "statusCode" : response.response?.statusCode ?? "",
            "data": self.convertToDictionary(text: response.value ?? "") ?? response.value ?? "",
            "headers": response.response?.headers.dictionary ?? [String:String](),
            "statusText": HTTPURLResponse.localizedString(forStatusCode: response.response?.statusCode ?? 0)
        ]
        handler(self.convertToJsonString(obj: dic)!, true)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArray(text: String) -> [Dictionary<String, String>]? {
        let arr = [Dictionary<String,String>()]
        do {
            let data = text.data(using: String.Encoding.utf8)!
            let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            return json as? [Dictionary<String, String>]
        }catch{
            return arr
        }
    }
    
    func convertToJsonString(obj: Any) -> String? {
        do {
            // here jsonData is the dictionary encoded in JSON data
            let jsonData:Data = try JSONSerialization.data(
                withJSONObject: obj,
                options: .prettyPrinted
            )

            // get a JSON string from jsonData object
            let jsonString:String = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch {
            return ""
        }
    }
}



// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Kingfisher
import LTXiOSUtils
import Shared
import Storage
import WebKit
import APIService

protocol IMSScriptDelegate: AnyObject {
    func onPageStatusAsync(status: String)
    func getCurTabWebView() -> TabWebView?
    func callTosJS(name: String, data: Any?, id: String?)
}

let IMSScriptNamespace = "window.imtExtensionBridge"

class IMSScript: TabContentScript {
    weak var delegate: IMSScriptDelegate?

    static let defaultPageStatus = "Original"

    private var logger: Logger
    fileprivate weak var tab: Tab?
    var pageStatus = "Original"

    fileprivate var originalURL: URL?

    class func name() -> String {
        return "IMSScript"
    }

    required init(tab: Tab, logger: Logger = DefaultLogger.shared) {
        self.tab = tab
        self.logger = logger
    }

    func scriptMessageHandlerNames() -> [String]? {
        return ["imsScriptMessageHandler"]
    }

    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage
    ) {
        guard let res = message.body as? [String: Any] else { return }
        Log.d("js请求: \(JSON(res))")
        let json = JSON(res)
        let type = json["type"].stringValue
        let id = json["id"].stringValue
        let dataJSON = json["data"]
        if type.contains("."), type.components(separatedBy: ".").count == 2 {
            switch type {
            case "httpClient.request":
                let dict = dataJSON.dictionaryValue.reduce(into: [String: String]()) { $0[$1.key] = $1.value.stringValue }
                HttpClientJSObject().request(dict) { [weak self] result, complete in
                    guard let self = self else { return }
                    self.delegate?.callTosJS(name: type.replaceFirstOccurrence(of: ".", with: "_"), data: result, id: id)
                }
            default:
                let webview = delegate?.getCurTabWebView()
                let argJSON = JSON(["data": dataJSON])
                let argStr = argJSON.rawString(options: [])
                let result = webview?.call(method: type, argStr: argStr)
                

                var dataToPass: Any? = nil
                if let resultString = result,
                   let data = resultString.data(using: .utf8) {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            dataToPass = jsonDict["data"]
                        }
                    } catch {
                        Log.e("Failed to parse result JSON: \(error)")
                    }
                }
                Log.d(dataToPass)
                self.delegate?.callTosJS(name: type.replaceFirstOccurrence(of: ".", with: "_"), data: dataToPass, id: id)
            }
        } else {
            switch type {
            case "getPageStatus":
                if let status = dataJSON["status"].string {
                    pageStatus = status
                    delegate?.onPageStatusAsync(status: status)
                }
            case "updatePageStatus":
                if let status = dataJSON["status"].string {
                    pageStatus = status
                    delegate?.onPageStatusAsync(status: status)
                }
                self.delegate?.callTosJS(name: "updatePageStatus", data: nil, id: id)
            case "getBaseInfo":
                let data: [String: Any] = [
                    "appVersion": AppInfo.appVersion,
                    "osVersion": UIDevice.current.systemVersion,
                    "deviceModel": DeviceInfo.specificModelName,
                    "deviceType": AdjustTrackManager.shared.getCurrentDeviceTypeName(),
                    "network": Reach().connectionStatus().description
                ]
                self.delegate?.callTosJS(name: "getBaseInfo", data: ["data": data], id: id)
            case "imageLongPress":
                imageLongPress(dataJSON: dataJSON)
            case "imageTextRecognition":
                imageTextRecognition(id: id, dataJSON: dataJSON)
            default:
                break
            }
        }
    }
}

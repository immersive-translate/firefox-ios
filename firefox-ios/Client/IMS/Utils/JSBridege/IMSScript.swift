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

protocol IMSScriptDelegate: AnyObject {
    func onPageStatusAsync(status: String)
    func callTosJS(name: String, data: [String: Any]?)
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
        switch type {
        case "getPageStatus":
            if let status = dataJSON["status"].string {
                pageStatus = status
                delegate?.onPageStatusAsync(status: status)
            }
        case "imageLongPress":
            imageLongPress(dataJSON: dataJSON)
        case "imageTextRecognition":
            imageTextRecognition(id: id, dataJSON: dataJSON)
        default:
            break
        }
    }
}

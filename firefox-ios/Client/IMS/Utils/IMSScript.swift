// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import Storage
import WebKit


protocol IMSScriptDelegate: AnyObject {
    func onPageStatusAsync(status: String)
}

let IMSScriptNamespace = "window.__firefox__.IMSScript"

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

    required init(tab: Tab,
                  logger: Logger = DefaultLogger.shared) {
        self.tab = tab
        self.logger = logger
    }

    func scriptMessageHandlerNames() -> [String]? {
        return ["imsScriptMessageHandler"]
    }
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage
    ) {
        guard let res = message.body as? [String: Any],
              let type = res["type"] as? String
        else { return }
        switch type {
        case "getPageStatusAsync":
            if let value = res["value"] as? String {
                pageStatus = value
                self.delegate?.onPageStatusAsync(status: value)
            }
        default:
            break
        }
    }
}

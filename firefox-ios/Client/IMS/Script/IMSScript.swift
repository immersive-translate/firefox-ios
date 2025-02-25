// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import Storage
import WebKit


protocol IMSScriptDelegate: AnyObject {
    
}

let IMSScriptNamespace = "window.__firefox__.IMSScript"

class IMSScript: TabContentScript {
    weak var delegate: IMSScriptDelegate?
    
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
        
        
    }
}

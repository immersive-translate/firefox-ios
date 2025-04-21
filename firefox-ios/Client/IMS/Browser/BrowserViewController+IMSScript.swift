// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Photos
import UIKit
import WebKit
import Shared
import Storage
import SnapKit
import Account
import MobileCoreServices
import Common
import ComponentLibrary
import Redux
import ToolbarKit
import LTXiOSUtils
import SwiftyJSON

extension BrowserViewController: IMSScriptDelegate {
    func onPageStatusAsync(status: String) {
        switch status {
        case "Translated":
            imsStore.dispatch(
                IMSToolbarTranslateAction(
                    windowUUID: windowUUID,
                    actionType: IMSToolbarTranslateActionType.translated
                )
            )
        case "Original":
            imsStore.dispatch(
                IMSToolbarTranslateAction(
                    windowUUID: windowUUID,
                    actionType: IMSToolbarTranslateActionType.origin
                )
            )
        default:
            break
        }
    }
    
    func callTosJS(name: String, data: Any?, id: String?) {
        guard let tab = tabManager.selectedTab, let webView = tab.webView else { return }
        
        var payload: [String: Any] = [:]
        
        // Check the type of data and add it to the payload if it's a Dictionary or String
        if let dataDict = data as? [String: Any] {
            payload["data"] = dataDict
        } else if let dataString = data as? String {
            payload["data"] = dataString
        }
        
        if let id = id {
            payload["id"] = id
        }

        var result = "\(IMSScriptNamespace).\(name)()"
        if !payload.isEmpty {
            let dataStr = JSON(payload).rawString(options: []) ?? "{}"
            result = "\(IMSScriptNamespace).\(name)(\(dataStr))"
        }

        webView.evaluateJavascriptInDefaultContentWorld(result) { object, error in
            Log.d(object)
            Log.d(error)
        }
    }
    
    func getCurTabWebView() -> TabWebView? {
        guard let tab = tabManager.selectedTab else { return nil}
        return tab.webView
    }
}

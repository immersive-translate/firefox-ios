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
    
    func callTosJS(name: String, data: [String: Any]?) {
        guard let tab = tabManager.selectedTab, let webView = tab.webView else { return }
        var result = "\(IMSScriptNamespace).\(name)()"
        if let data = data {
            let dataStr = JSON(data).rawString(options: []) ?? ""
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

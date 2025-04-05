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
    
    func feedbackImage(url: String) {
        guard let tab = tabManager.selectedTab, let webView = tab.webView else { return }
        webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).openImageTranslationFeedback()") { object, error in
   
        }
    }
    
    func translateImage(url: String) {
        guard let tab = tabManager.selectedTab, let webView = tab.webView else { return }
        webView.evaluateJavascriptInDefaultContentWorld("\(IMSScriptNamespace).translateImage(\'\(url)\')") { object, error in
            Log.d(object)
            Log.d(error)
        }
    }
    
    func restoreImage(url: String) {
        
    }
}

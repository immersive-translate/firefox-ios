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
}

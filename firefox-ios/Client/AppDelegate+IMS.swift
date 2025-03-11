// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import APIService
import SwiftyJSON
import LTXiOSUtils

extension AppDelegate {
    func didFinishLaunch() {
        IMSAccountManager.shard.setup()
        DebugToolManager.shared.reload()
        setupThirdLib()
    }
}

extension AppDelegate {
    private func setupThirdLib() {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        if UserDefaultsConfig.debugLog {
            Log.enabled = true
        }
//        APIService.sendRequest(APPAPI.GlobalConfigRequest()) { response in
//            switch response.result.validateResult {
//            case let .success(info):
//                Log.d(JSON(response.data))
//            case .failure:
//                ()
//            }
//        }
    }
}

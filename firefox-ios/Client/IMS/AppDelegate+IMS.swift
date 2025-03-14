// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import APIService
import SwiftyJSON
import LTXiOSUtils

extension AppDelegate {
    func willFinishLaunch() {
        reloadKeychain()
        IMSAccountManager.shard.setup()
        DebugToolManager.shared.reload()
        IMSAPPConfigUtils.shared.refresh()
        setupThirdLib()
    }
    
    func didFinishLaunch() {
        reloadKeychain()
        IMSAccountManager.shard.setup()
        DebugToolManager.shared.reload()
        IMSAPPConfigUtils.shared.refresh()
        setupThirdLib()
    }
    
    /// 绕开之前app第一次启动会删除keychain的逻辑
    private func reloadKeychain() {
        StoreConfig.networkEnvStr = StoreConfig.networkEnvStr
        StoreConfig.debugLog = StoreConfig.debugLog
        StoreConfig.showDebugTool = StoreConfig.showDebugTool
    }
}

extension AppDelegate {
    private func setupThirdLib() {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        if StoreConfig.debugLog {
            Log.enabled = true
        }
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import APIService
import SwiftyJSON
import LTXiOSUtils
#if FENNEC_DEBUG
import LookinServer
#endif
extension AppDelegate {
    func willFinishLaunch() {
        reloadKeychain()
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
        StoreConfig.showDebugTool = StoreConfig.showDebugTool
    }
}

extension AppDelegate {
    private func setupThirdLib() {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMaximumDismissTimeInterval(2.5)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14))
        SVProgressHUD.setBackgroundColor(.black.withAlphaComponent(0.5))
        SVProgressHUD.setInfoImage(UIColor.clear.tx.toImage(size: CGSize(width: 0.1, height: 0.1))!)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setErrorImage(UIImage(named: "toast_error")!)
        SVProgressHUD.setSuccessImage(UIImage(named: "toast_success")!)
        #if FENNEC_DEBUG
            Log.enabled = true
            LKS_ConnectionManager.sharedInstance()
        #endif
    }
}

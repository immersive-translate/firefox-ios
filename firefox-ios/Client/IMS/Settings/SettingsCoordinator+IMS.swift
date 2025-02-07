// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Foundation
import Shared
import Redux

// MARK: - IMSAccountSettingDelegate

extension SettingsCoordinator: IMSAccountSettingDelegate {
    
    func pressedIMSAccountUpgrade(userInfo: IMSAccountInfo) {
        let viewController = IMSAccountUpgradeViewController(userInfo: userInfo, windowUUID: windowUUID)
        viewController.profile = profile
        viewController.parentCoordinator = self;
        router.push(viewController)
    }
}

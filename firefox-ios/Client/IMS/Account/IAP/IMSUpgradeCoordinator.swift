// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Foundation
import MenuKit
import Shared

class IMSUpgradeCoordinator: BaseCoordinator, FeatureFlaggable {
    let windowUUID: WindowUUID
    
    init(
        router: Router,
        windowUUID: WindowUUID,
        profile: Profile
    ) {
        self.windowUUID = windowUUID
        super.init(router: router)
    }

    func start() {
        router.setRootViewController(
            createUpgradeViewController(),
            hideBar: true
        )
    }
    
    private func createUpgradeViewController() -> UIViewController {
        let viewController = IMSAccountUpgradeViewController(userInfo: nil, windowUUID: windowUUID)
        return viewController
    }
}

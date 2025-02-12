// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import MenuKit
import Shared

class ModalBrowserCoordinator: BaseCoordinator, FeatureFlaggable {
    let windowUUID: WindowUUID
    let url: URL
    let profile: Profile
    
    init(
        url: URL,
        router: Router,
        windowUUID: WindowUUID,
        profile: Profile
    ) {
        self.url = url
        self.windowUUID = windowUUID
        self.profile = profile
        super.init(router: router)
    }
    
    deinit {
        print("")
    }
    
    func start() {
        router.setRootViewController(
            createModalBrowserViewController(),
            hideBar: true
        )
    }
    
    func createModalBrowserViewController() -> UIViewController {
        let modalBrowserViewController = ModalBrowserViewController(url: url, profile: profile, windowUUID: windowUUID)
        modalBrowserViewController.coordinator = self
        return modalBrowserViewController
    }

    func webViewDidClose() {
        router.dismiss(animated: true)
    }
}

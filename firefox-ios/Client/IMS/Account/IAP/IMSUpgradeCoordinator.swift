// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Foundation
import MenuKit
import Shared
import SVProgressHUD

class IMSUpgradeCoordinator: BaseCoordinator, FeatureFlaggable {
    let windowUUID: WindowUUID
    let profile: Profile
    weak var parentCoordinator: ParentCoordinatorDelegate?
    weak var navigationHandler: MainMenuCoordinatorDelegate?
    
    var rootViewController: IMSAccountUpgradeViewController?
    
    init(
        router: Router,
        windowUUID: WindowUUID,
        profile: Profile
    ) {
        self.windowUUID = windowUUID
        self.profile = profile
        super.init(router: router)
    }

    func start() {
        router.setRootViewController(
            createUpgradeViewController(),
            hideBar: true
        )
    }
    
    deinit {
        print("")
    }
    
    private func createUpgradeViewController() -> UIViewController {
        let viewController = IMSAccountUpgradeViewController(windowUUID: windowUUID)
        viewController.viewModel.coordinator = self
        self.rootViewController = viewController
        return viewController
    }
    
    func showLoginModalWebView() {
        guard let url = URL(string: IMSAppUrlConfig.login + "?app_action=gotoUpgrade") else { return }
        let navigationController = DismissableNavigationViewController()
        let coordinator = ModalBrowserCoordinator(
            url: url,
            router: DefaultRouter(navigationController: navigationController),
            windowUUID: windowUUID,
            profile: profile
        )
        navigationController.onViewDismissed = { [weak self] in
            self?.parentCoordinator?.didFinish(from: coordinator)
            Task {
                await self?.rootViewController?.viewModel.fetchProductInfos()
            }
        }
        
        coordinator.start()
        
        router.present(navigationController)
    }
    
    func showPurchaseSuccess() {
        SVProgressHUD.show()
        let navigationHandler = self.navigationHandler
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            SVProgressHUD.dismiss()
            self?.router.dismiss(animated: true, completion: {
                navigationHandler?.openURLInNewTab(URL(string: IMSAppUrlConfig.purchaseSuccess))
            })
        }
    }
}

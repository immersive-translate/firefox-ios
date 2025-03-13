// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

protocol IMSBrowserCoordinatorDelegate: AnyObject {
    func showIMSUpgradeViewController()
    
    func showIMSFeedbackViewController()
}

extension BrowserCoordinator: IMSBrowserCoordinatorDelegate {
    
    func showIMSUpgradeViewController() {
        let navigationController = DismissableNavigationViewController()
        let coordinator = IMSUpgradeCoordinator(
            router: DefaultRouter(navigationController: navigationController),
            windowUUID: windowUUID,
            profile: profile
        )
        coordinator.parentCoordinator = self
        coordinator.navigationHandler = self
        add(child: coordinator)
        
        navigationController.onViewDismissed = {[weak self] in
            self?.didFinish(from: coordinator)
        }
        coordinator.start()
        
        router.present(navigationController)
    }
    
    func showIMSFeedbackViewController() {
        let viewController = IMSFeedbackViewController()
        viewController.windowUUID = windowUUID
        RouterManager.shared.present(DismissableNavigationViewController(rootViewController: viewController), animated: true)
    }
    
}

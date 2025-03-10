// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

final class RouterManager {
    static let shared = RouterManager()

    private init() {}
}


extension RouterManager {
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let vc = UIViewController.tx.topViewController()
        vc?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        UIViewController.tx.topViewController()?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

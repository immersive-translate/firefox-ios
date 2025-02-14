// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import UIKit
import Common
import Shared
import StoreKit
import SVProgressHUD
import SwiftUI

class OnboardingLoginViewController: UIViewController {
    var onButtonTap: ((OnboardingLoginButtonType) -> Void)?
    
    var hostingViewController: UIHostingController<OnboardingLoginView>?
    
    init(onButtonTap: ( (OnboardingLoginButtonType) -> Void)? = nil) {
        self.onButtonTap = onButtonTap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: OnboardingLoginView(onButtonTap: self.onButtonTap))
        self.view.addSubview(hostingController.view)
        self.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        self.hostingViewController = hostingController
    }
}

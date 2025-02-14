// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import Shared
import StoreKit
import SVProgressHUD
import SwiftUI

class IMSAccountUpgradeViewController: SettingsViewController, AppSettingsScreen {
    weak var parentCoordinator: SettingsFlowDelegate?
    
    var subscriptionHostingController: UIHostingController<ProSubscriptionSwiftUIView>?
    
    let viewModel: ProSubscriptionViewModel
    
    init(profile: Profile? = nil,
         tabManager: TabManager? = nil,
         windowUUID: WindowUUID,
         fromSource: ProSubscriptionFromSource = .upgrade) {
        self.viewModel = ProSubscriptionViewModel(fromSource: fromSource)
        super.init(windowUUID: windowUUID, profile: profile, tabManager: tabManager)
        self.title = .IMS.Settings.Upgrade
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: ProSubscriptionSwiftUIView(viewModel: self.viewModel))
        self.view.addSubview(hostingController.view)
        self.addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        self.subscriptionHostingController = hostingController
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        SVProgressHUD.dismiss()
    }
    
    func handle(route: Route.SettingsSection) {
        
    }
    
    
}

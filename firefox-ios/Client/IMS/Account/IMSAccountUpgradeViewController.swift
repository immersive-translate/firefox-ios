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
    var parentCoordinator: SettingsFlowDelegate?
    
    var subscriptionHostingController: UIHostingController<ProSubscriptionSwiftUIView>?
    
    let token: String
    
    init(token: String,
         profile: Profile? = nil,
         tabManager: TabManager? = nil,
         windowUUID: WindowUUID) {
        self.token = token
        super.init(windowUUID: windowUUID, profile: profile, tabManager: tabManager)
        self.title = .IMS.Settings.Upgrade
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProductInfo()
    }
    
    
    
    func loadProductInfo() {
        SVProgressHUD.show()
        Task {
            do {
                let ret = try await IMSIAPHttpService.getConfig(token: IMSAccountConfig.testToken)
                guard let channel = ret.data.data.first else {
                    throw SKError(.clientInvalid)
                }
                let products = try await IMSAccountManager.shard.iap.getProducts(channel.goods.map{$0.appStoreId})
                guard !products.isEmpty, products.count == channel.goods.count else {
                    throw SKError(.clientInvalid)
                }
                var infos: [ProSubscriptionInfo] = []
                for good in channel.goods {
                    if let product = products.first(where: { $0.id == good.appStoreId }) {
                        infos.append(.init(serverProduct: good, appleProduct: product))
                    }
                }
                let config: ProSubscriptionConfig = .init(channelName: channel.channelName, channelIco: channel.channelIco, channelCode: channel.channelCode, symbol: channel.symbol, infos: infos)
                
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    let hostingController = UIHostingController(rootView: ProSubscriptionSwiftUIView(viewModel: .init(config: config)))
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
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "获取数据失败")
                }
            }
            
        }
        
    }
    
    func handle(route: Route.SettingsSection) {
        
    }
    
    
}

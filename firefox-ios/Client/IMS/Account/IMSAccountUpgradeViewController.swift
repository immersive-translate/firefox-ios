// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import Shared
import StoreKit
import SVProgressHUD

class IMSAccountUpgradeViewController: SettingsTableViewController, AppSettingsScreen {
    var parentCoordinator: SettingsFlowDelegate?
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(purchaseAction), for: .touchUpInside)
        return button
    }()
    
    init(prefs: Prefs, windowUUID: WindowUUID) {
        super.init(style: .plain, windowUUID: windowUUID)
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
                let product = try await IMSAccountManager.shard.iap.getProduct(productId: IMSAccountConfig.oneYearProductId)
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    self.updateProductInfo(product: product)
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "获取产品信息失败")
                }
            }
        }
    }
    
    @MainActor
    func updateProductInfo(product: StoreKit.Product) {
        if self.purchaseButton.superview == nil {
            self.view.addSubview(self.purchaseButton)
            
            NSLayoutConstraint.activate([
                self.purchaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.purchaseButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
        }
        self.purchaseButton.setTitle("\(product.displayName): \(product.displayPrice) \(product.description)", for: .normal)
    }
    
    
    @objc
    func purchaseAction() {
        SVProgressHUD.show()
        Task {
            do {
                try await IMSAccountManager.shard.iap.purchase(productId: IMSAccountConfig.oneYearProductId)
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "购买成功")
                }
            } catch {
                await MainActor.run {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: "购买失败")
                }
            }
        }
    }
    
    func handle(route: Route.SettingsSection) {
        
    }
    
    
}

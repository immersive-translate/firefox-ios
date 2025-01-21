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
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("刷新", for: .normal)
        button.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        return button
    }()
    
    lazy var productTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = IMSAccountConfig.oneYearProductId
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .lightGray
        return textField
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
        self.view.addSubview(self.productTextField)
        self.view.addSubview(self.refreshButton)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapViewAction))
        self.view.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            self.productTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.productTextField.widthAnchor.constraint(equalToConstant: 200),
            self.productTextField.heightAnchor.constraint(equalToConstant: 50),
            self.productTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.refreshButton.topAnchor.constraint(equalTo: self.productTextField.bottomAnchor, constant: 20),
            self.refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.refreshButton.widthAnchor.constraint(equalToConstant: 100),
            self.refreshButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
    
    
    @MainActor
    func updateProductInfo(product: StoreKit.Product) {
        if self.purchaseButton.superview == nil {
            self.view.addSubview(self.purchaseButton)
            
            NSLayoutConstraint.activate([
                self.purchaseButton.topAnchor.constraint(equalTo: self.refreshButton.bottomAnchor, constant: 20),
                self.purchaseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
        }
        self.purchaseButton.setTitle("购买：\(product.displayName): \(product.displayPrice) \(product.description)", for: .normal)
    }
    
    @objc
    func tapViewAction() {
        self.view.endEditing(true)
    }
    
    @objc
    func refreshAction() {
        loadProductInfo()
    }
    
    
    @objc
    func purchaseAction() {
        let subscriptionVC = ProSubscriptionViewController()
        present(subscriptionVC, animated: true)

//        guard let productId =  self.productTextField.text, !productId.isEmpty else {
//            SVProgressHUD.showError(withStatus: "请输入产品ID")
//            return
//        }
//        SVProgressHUD.show()
//        Task {
//            do {
//                try await IMSAccountManager.shard.iap.purchase(productId: productId)
//                await MainActor.run {
//                    SVProgressHUD.dismiss()
//                    SVProgressHUD.showSuccess(withStatus: "购买成功")
//                }
//            } catch {
//                await MainActor.run {
//                    SVProgressHUD.dismiss()
//                    SVProgressHUD.showError(withStatus: "购买失败")
//                }
//            }
//        }
    }
    
    func loadProductInfo() {
        guard let productId =  self.productTextField.text, !productId.isEmpty else {
            SVProgressHUD.showError(withStatus: "请输入产品ID")
            return
        }
        SVProgressHUD.show()
        Task {
            do {
                let product = try await IMSAccountManager.shard.iap.getProduct(productId: productId)
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
    
    func handle(route: Route.SettingsSection) {
        
    }
    
    
}

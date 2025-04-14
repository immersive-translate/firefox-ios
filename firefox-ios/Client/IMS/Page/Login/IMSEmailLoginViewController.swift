// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import AttributedString

class IMSEmailLoginViewController: BaseViewController {
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_back")
        imageView.addTapGesture { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        return imageView
    }()
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = ThemeColor.ZX.c333333
        label.text = "Imt.login.title".i18nImt()
        return label
    }()
        
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c333333
        label.text = "Imt.login.desc".i18nImt()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
        
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(loginButtonOnClick), for: .touchUpInside)
        button.setTitle("Imt.email_login.login_btn_text".i18nImt(), for: .normal)
        button.backgroundColor = ThemeColor.PP.EA4C89
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.account_title".i18nImt()
        return label
    }()
    
    private lazy var passowordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.pwd_title".i18nImt()
        return label
    }()
    
    private lazy var loginNameTextField: InputTextField = {
        let textField = InputTextField()
        textField.inputPlaceholder = "Imt.Setting.feedback.email.placeholder".i18nImt()
        textField.backgroundColor = ThemeColor.ZX.FFFFFF
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.inputPlaceholder = "Imt.email_login.pwd_hint".i18nImt()
        textField.backgroundColor = ThemeColor.ZX.FFFFFF
        return textField
    }()
    
    private lazy var forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c999999
        label.text = "Imt.email_login.forget_pwd".i18nImt()
        label.addTapGesture { [weak self] _ in
            self?.forgetPasswordOnClick()
        }
        return label
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.CCCCCC
        label.text = "Imt.email_login.auto_register".i18nImt()
        return label
    }()
        
    private lazy var bottomImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_bottom")
        return imageView
    }()
        
    private lazy var policyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c999999
        let press = ASAttributedString.Action(.press, highlights: [.background(.clear)]) { _ in }
        let termOnClick = ASAttributedString.Action(.click) { [weak self] _ in
            self?.termOnClick()
        }
        let privacyOnClick = ASAttributedString.Action(.click) { [weak self] _ in
            self?.privacyOnClick()
        }

        let message: ASAttributedString = "\("Imt.login.hw_agreement".i18nImt()) \("Imt.login.hw_condition".i18nImt(), .action(press), .action(termOnClick), .foreground(ThemeColor.Other.c4181F0)) \("Imt.Localizable.Reminder.Middle".i18nImt()) \("Imt.login.hw_privacy".i18nImt(), .action(press), .action(privacyOnClick), .foreground(ThemeColor.Other.c4181F0))"
        label.attributed.text = message
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
        
    private func setupUI() {
        let bgImageView = UIImageView(image: UIImage(named: "login_bg"))
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(20)
        }
            
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backImageView.snp.bottom).offset(DeviceUtils.isIpad ? 156 : 22)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
            
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(loginNameLabel)
        view.addSubview(loginNameTextField)
        view.addSubview(passowordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgetPasswordLabel)
        view.addSubview(tipsLabel)
        
        loginNameLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(32)
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
            make.width.equalTo(307)
        }
        
        loginNameTextField.snp.makeConstraints { make in
            make.top.equalTo(loginNameLabel.snp.bottom).offset(8)
            make.width.equalTo(315)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        passowordLabel.snp.makeConstraints { make in
            make.top.equalTo(loginNameTextField.snp.bottom).offset(8)
            make.width.height.centerX.equalTo(loginNameLabel)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passowordLabel.snp.bottom).offset(8)
            make.width.height.centerX.equalTo(loginNameTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(58)
            make.width.height.centerX.equalTo(loginNameTextField)
        }
        
        forgetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
        }
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(forgetPasswordLabel.snp.bottom).offset(16)
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
        }
            
        view.addSubview(bottomImageView)
        view.addSubview(policyLabel)
            
        policyLabel.snp.makeConstraints { make in
            if DeviceUtils.isIpad {
                make.top.equalTo(tipsLabel.snp.bottom).offset(246)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-29)
            }
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        bottomImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(policyLabel.snp.top).offset(-26)
        }
    }
}

extension IMSEmailLoginViewController {
    @objc
    private func loginButtonOnClick() {
        guard let loginName = loginNameTextField.text, !loginName.isEmpty else {
            SVProgressHUD.toast(loginNameTextField.inputPlaceholder)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.toast(passwordTextField.inputPlaceholder)
            return
        }
        let request = UserAccountAPI.WebLoginRequest(loginType: .email(loginName, password))
        SVProgressHUD.show()
        APIService.sendRequest(request) { [weak self] response in
            guard let self = self else { return }
            switch response.validateResult {
            case .success:
                SVProgressHUD.dismiss()
                if let data = response.data {
                    SVProgressHUD.toast("Imt.login.success".i18nImt())
                    let json = JSON(data)
                    let loginResult = json["data"]["loginResult"]
                    var user = loginResult["user"]
                    /// 兼容js的处理
                    user["token"] = loginResult["token"]
                    IMSUserManager.shared.setUserInfo(info: user)
                    
                    if let nav = self.navigationController {
                        let viewControllers = nav.viewControllers
                        if viewControllers.count >= 3 {
                            let targetVC = viewControllers[viewControllers.count - 3]
                            nav.popToViewController(targetVC, animated: true)
                        } else {
                            nav.popToRootViewController(animated: false)
                            nav.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            case let .failure(msg, code, error):
                if code == IMSBaseResponseModelCode.notRegistered.rawValue {
                    toRegister(loginName: loginName, password: password)
                    return
                } else if code == IMSBaseResponseModelCode.notActivated.rawValue {
                    toActivate(loginName: loginName, password: password)
                    return
                }
                SVProgressHUD.dismiss()
                if let code = code, let i18nError = "Imt.error.account_login_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
    }
    
    private func toRegister(loginName: String, password: String) {
        let request = UserAccountAPI.RegisterRequest(email: loginName, password: password)
        APIService.sendRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.allowNullValidateResult {
            case .success:
                let viewController = IMSEmailVerificationCodeViewController()
                viewController.loginName = loginName
                viewController.password = password
                viewController.activateSuccessCallback = { [weak self] in
                    guard let self = self else { return }
                    self.loginButtonOnClick()
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.register_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
    }
    
    private func toActivate(loginName: String, password: String) {
        let request = UserAccountAPI.ReActivateRequest(email: loginName)
        APIService.sendRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.allowNullValidateResult {
            case .success:
                let viewController = IMSEmailVerificationCodeViewController()
                viewController.loginName = loginName
                viewController.password = password
                viewController.activateSuccessCallback = { [weak self] in
                    guard let self = self else { return }
                    self.loginButtonOnClick()
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.re_active_code_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
    }
    
    private func forgetPasswordOnClick() {
        let viewController = IMSResetPasswordViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
        
    private func termOnClick() {
        let viewController = BaseBrowserViewController()
        viewController.url = IMSAppUrlConfig.terms
        RouterManager.shared.present(viewController, animated: true)
    }
    
    private func privacyOnClick() {
        let viewController = BaseBrowserViewController()
        viewController.url = IMSAppUrlConfig.privacy
        RouterManager.shared.present(viewController, animated: true)
    }
}

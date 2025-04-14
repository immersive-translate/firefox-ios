// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import AttributedString

class IMSEmailVerificationCodeViewController: BaseViewController {
    var loginName: String?
    var password: String?
    
    var activateSuccessCallback: (() -> Void)?
    
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
        button.setTitle("Imt.email_verify.btn_verify".i18nImt(), for: .normal)
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

    private lazy var activationCodeTextField: VerificationCodeTextField = {
        let textField = VerificationCodeTextField()
        textField.inputPlaceholder = "Imt.email_verify.email_hint".i18nImt()
        textField.backgroundColor = ThemeColor.ZX.FFFFFF
        return textField
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c999999
        let press = ASAttributedString.Action(.press, highlights: [.background(.clear)]) { _ in }
        let loginOnClick = ASAttributedString.Action(.click) { [weak self] _ in
            self?.loginOnClick()
        }
        let message: ASAttributedString = "\("Imt.email_verify.account_desc".i18nImt())\("Imt.email_verify.account_login".i18nImt(), .action(press), .action(loginOnClick), .foreground(ThemeColor.Other.c4181F0))"
        label.attributed.text = message
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
        setupEvent()
        loginNameLabel.text = loginName
        activationCodeTextField.startCountdown()
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
        view.addSubview(activationCodeTextField)
        view.addSubview(loginButton)
        view.addSubview(tipsLabel)
        
        loginNameLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(32)
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
            make.width.equalTo(307)
        }
        
        activationCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(loginNameLabel.snp.bottom).offset(8)
            make.width.equalTo(315)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(activationCodeTextField.snp.bottom).offset(32)
            make.width.height.centerX.equalTo(activationCodeTextField)
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(24)
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
    
    private func setupEvent() {
        activationCodeTextField.callback = { [weak self] complete in
            guard let self = self else { return }
            getData(complete: complete)
        }
    }
    
    private func getData(complete: ((Bool) -> Void)? = nil) {
        guard let loginName = loginName else {
            return
        }
        let request = UserAccountAPI.ReActivateRequest(email: loginName)
        SVProgressHUD.show()
        APIService.sendRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.allowNullValidateResult {
            case .success:
                complete?(true)
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.re_active_code_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
                complete?(false)
            }
        }
    }
}

extension IMSEmailVerificationCodeViewController {
    @objc
    private func loginButtonOnClick() {
        guard let loginName = loginName else {
            return
        }
        guard let activationCode = activationCodeTextField.text, !activationCode.isEmpty else {
            SVProgressHUD.toast(activationCodeTextField.inputPlaceholder)
            return
        }
        let request = UserAccountAPI.ActivateRequest(activationCode: activationCode, email: loginName)
        SVProgressHUD.show()
        APIService.sendRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.allowNullValidateResult {
            case .success:
                self.activateSuccessCallback?()
                self.navigationController?.popViewController(animated: true)
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.account_activate_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
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
    
    private func loginOnClick() {
        navigationController?.popViewController(animated: true)
    }
}

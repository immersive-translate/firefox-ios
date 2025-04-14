// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

class IMSResetPasswordViewController: BaseViewController {
    private lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.account_title".i18nImt()
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.reset_verify_code".i18nImt()
        return label
    }()
    
    private lazy var passowordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.reset_pwd".i18nImt()
        return label
    }()
    
    private lazy var surePassowordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.email_login.reset_pwd_confirm".i18nImt()
        return label
    }()
    
    private lazy var loginNameTextField: InputTextField = {
        let textField = InputTextField()
        textField.inputPlaceholder = "Imt.Setting.feedback.email.placeholder".i18nImt()
        textField.backgroundColor = ThemeColor.TC.FAFBFC
        return textField
    }()
    
    private lazy var codeTextField: VerificationCodeTextField = {
        let textField = VerificationCodeTextField()
        textField.inputPlaceholder = "Imt.email_login.reset_verify_code_hint".i18nImt()
        textField.backgroundColor = ThemeColor.TC.FAFBFC
        return textField
    }()
    
    private lazy var passwordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.inputPlaceholder = "Imt.email_login.pwd_hint".i18nImt()
        textField.backgroundColor = ThemeColor.TC.FAFBFC
        return textField
    }()
    
    private lazy var surePasswordTextField: PasswordTextField = {
        let textField = PasswordTextField()
        textField.inputPlaceholder = "Imt.email_login.pwd_hint".i18nImt()
        textField.backgroundColor = ThemeColor.TC.FAFBFC
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionButtonOnClick), for: .touchUpInside)
        button.setTitle("Imt.email_login.reset_title".i18nImt(), for: .normal)
        button.backgroundColor = ThemeColor.PP.EA4C89
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private lazy var inputContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var successView: UIView = {
        let view = UIView()
        let icon = UIImageView(image: UIImage(named: "reset_password_success"))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.YY.c21BB45
        label.text = "Imt.email_login.reset_ok".i18nImt()
        view.addSubview(icon)
        view.addSubview(label)
        icon.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(72)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
        }
        return view
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Imt.email_login.reset_title".i18nImt()
        setupUI()
        setupEvent()
    }
    
    private func setupUI() {
        view.addSubview(successView)
        successView.isHidden = true
        successView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.width.equalTo(110)
            make.height.equalTo(90)
        }
        
        view.addSubview(inputContentView)
        inputContentView.addSubview(loginNameLabel)
        inputContentView.addSubview(codeLabel)
        inputContentView.addSubview(passowordLabel)
        inputContentView.addSubview(surePassowordLabel)
        inputContentView.addSubview(loginNameTextField)
        inputContentView.addSubview(codeTextField)
        inputContentView.addSubview(passwordTextField)
        inputContentView.addSubview(surePasswordTextField)
        view.addSubview(actionButton)
        
        inputContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(DeviceUtils.isIpad ? 156 : 20)
            make.left.right.equalToSuperview()
        }
        
        loginNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(loginNameTextField.snp.bottom).offset(16)
            make.width.height.centerX.equalTo(loginNameLabel)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(8)
            make.width.height.centerX.equalTo(loginNameTextField)
        }
        
        passowordLabel.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(16)
            make.width.height.centerX.equalTo(loginNameLabel)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passowordLabel.snp.bottom).offset(8)
            make.width.height.centerX.equalTo(loginNameTextField)
        }
        
        surePassowordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.width.height.centerX.equalTo(loginNameLabel)
        }
        
        surePasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(surePassowordLabel.snp.bottom).offset(8)
            make.width.height.centerX.equalTo(loginNameTextField)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        actionButton.snp.makeConstraints { make in
            if DeviceUtils.isIpad {
                make.top.equalTo(surePasswordTextField.snp.bottom).offset(246)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
            make.width.height.centerX.equalTo(loginNameTextField)
        }
    }
    
    private func setupEvent() {
        codeTextField.callback = { [weak self] complete in
            guard let self = self else { return }
            guard let loginName = loginNameTextField.text, !loginName.isEmpty else {
                SVProgressHUD.toast(loginNameTextField.inputPlaceholder)
                complete(false)
                return
            }
            let request = UserAccountAPI.FindPasswordCodeRequest(email: loginName)
            SVProgressHUD.show()
            APIService.sendRequest(request) { response in
                SVProgressHUD.dismiss()
                switch response.allowNullValidateResult {
                case .success:
                    complete(true)
                case let .failure(msg, code, error):
                    if let code = code, let i18nError = "Imt.error.find_pwd_verify_\(code)".i18nImtWithCheck() {
                        SVProgressHUD.toast(i18nError)
                    } else {
                        SVProgressHUD.toast(msg ?? error.localizedDescription)
                    }
                    complete(false)
                }
            }
        }
    }
}

extension IMSResetPasswordViewController {
    @objc
    private func actionButtonOnClick() {
        if successView.isHidden == false {
            navigationController?.popViewController(animated: true)
            return
        }
        guard let loginName = loginNameTextField.text, !loginName.isEmpty else {
            SVProgressHUD.toast(loginNameTextField.inputPlaceholder)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.toast(passwordTextField.inputPlaceholder)
            return
        }
        guard let surePassword = surePasswordTextField.text, !surePassword.isEmpty else {
            SVProgressHUD.toast(surePasswordTextField.inputPlaceholder)
            return
        }
        guard let code = codeTextField.text, !code.isEmpty else {
            SVProgressHUD.toast(codeTextField.inputPlaceholder)
            return
        }
        guard password == surePassword else {
            SVProgressHUD.toast("Imt.password.must_match".i18nImt())
            return
        }
        
        let request = UserAccountAPI.ResetPasswordRequest(password: password, resetCode: code, userEmail: loginName)
        SVProgressHUD.show()
        APIService.sendRequest(request) { response in
            SVProgressHUD.dismiss()
            switch response.allowNullValidateResult {
            case .success:
                self.inputContentView.isHidden = true
                self.successView.isHidden = false
                self.actionButton.setTitle("Imt.email_login.reset_goto_login".i18nImt(), for: .normal)
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.reset_password_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
    }
}

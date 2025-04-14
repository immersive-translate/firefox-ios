// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import AttributedString
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import LTXiOSUtils
import SwiftyJSON

class IMSLoginViewController: BaseViewController {
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_back")
        imageView.addTapGesture { [weak self] _ in
            guard let self = self else { return }
            self.closePage()
        }
        return imageView
    }()
    
    private lazy var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_close")
        imageView.addTapGesture { [weak self] _ in
            guard let self = self else { return }
            self.closePage()
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
    
    private lazy var googleButton: LoginTypeButton = {
        let button = LoginTypeButton()
        button.addTarget(self, action: #selector(googleOnClick), for: .touchUpInside)
        button.type = .google
        return button
    }()

    private lazy var emailButton: LoginTypeButton = {
        let button = LoginTypeButton()
        button.type = .email
        button.addTarget(self, action: #selector(emailOnClick), for: .touchUpInside)
        return button
    }()

    private lazy var appleButton: LoginTypeButton = {
        let button = LoginTypeButton()
        button.type = .apple
        button.addTarget(self, action: #selector(appleOnClick), for: .touchUpInside)
        return button
    }()

    private lazy var facebookButton: LoginTypeButton = {
        let button = LoginTypeButton()
        button.type = .facebook
        button.addTarget(self, action: #selector(facebookOnClick), for: .touchUpInside)
        return button
    }()

    private lazy var weixinButton: LoginTypeButton = {
        let button = LoginTypeButton()
        button.type = .weixin
        button.addTarget(self, action: #selector(weixinOnClick), for: .touchUpInside)
        return button
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
        if self.presentingViewController != nil {
            backImageView.isHidden = true
            closeImageView.isHidden = false
        } else {
            backImageView.isHidden = false
            closeImageView.isHidden = true
        }
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
        
        view.addSubview(closeImageView)
        closeImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalToSuperview().offset(-20)
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
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        view.addSubview(googleButton)
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        let lineStackView = UIStackView()
        let leftLineView = UIView()
        leftLineView.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        leftLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.lessThanOrEqualTo(122)
        }
        leftLineView.backgroundColor = ThemeColor.ZX.CCCCCC
        let rightLineView = UIView()
        rightLineView.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        rightLineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.lessThanOrEqualTo(122)
        }
        rightLineView.backgroundColor = ThemeColor.ZX.CCCCCC
        let lineLabel = UILabel()
        lineLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        lineLabel.text = "Imt.login.or".i18nImt()
        lineLabel.font = UIFont.systemFont(ofSize: 14)
        lineLabel.textColor = ThemeColor.ZX.CCCCCC
        lineStackView.addArrangedSubview(leftLineView)
        lineStackView.addArrangedSubview(lineLabel)
        lineStackView.addArrangedSubview(rightLineView)
        lineStackView.spacing = 9
        lineStackView.alignment = .center
        view.addSubview(lineStackView)
        lineStackView.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(275)
        }
        
        let loginStackView = UIStackView()
        loginStackView.axis = .vertical
        loginStackView.spacing = 16
        loginStackView.addArrangedSubview(emailButton)
        loginStackView.addArrangedSubview(appleButton)
        loginStackView.addArrangedSubview(facebookButton)
//        loginStackView.addArrangedSubview(weixinButton)
        view.addSubview(loginStackView)
        loginStackView.snp.makeConstraints { make in
            make.top.equalTo(lineStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(315)
        }
        
        view.addSubview(bottomImageView)
        view.addSubview(policyLabel)
        
        policyLabel.snp.makeConstraints { make in
            if DeviceUtils.isIpad {
                make.top.equalTo(loginStackView.snp.bottom).offset(246)
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

extension IMSLoginViewController {
    @objc
    private func googleOnClick() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self else { return }
            guard error == nil else { return }
            let token = signInResult?.user.accessToken.tokenString ?? ""
            self.oauthCallback(type: .google(token))
        }
    }
    
    @objc
    private func emailOnClick() {
        let viewController = IMSEmailLoginViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func appleOnClick() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc
    private func facebookOnClick() {
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                SVProgressHUD.toast(error.localizedDescription)
            } else if let result = result, !result.isCancelled {
                let token = AccessToken.current?.tokenString ?? ""
                Log.d("Token: \(token)")
                self.oauthCallback(type: .facebook(token))
            } else {
                Log.d("User cancelled Facebook login")
            }
        }
    }
    
    @objc
    private func weixinOnClick() {

    }
    
    private func closePage() {
        if self.presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func termOnClick() {
        let viewController = BaseBrowserViewController()
        viewController.url = IMSAppUrlConfig.terms
        RouterManager.shared.present(BaseNavigationController(rootViewController: viewController), animated: true)
    }
    
    private func privacyOnClick() {
        let viewController = BaseBrowserViewController()
        viewController.url = IMSAppUrlConfig.privacy
        RouterManager.shared.present(BaseNavigationController(rootViewController: viewController), animated: true)
    }
    
    private func oauthCallback(type: UserAccountAPI.OauthCallbackType) {
        let request = UserAccountAPI.WebOauthCallbackRequest(oauthCallbackType: type)
        SVProgressHUD.show()
        APIService.sendRequest(request) { [weak self] response in
            SVProgressHUD.dismiss()
            guard let self = self else { return }
            switch response.validateResult {
            case let .success(info):
                Log.d(info)
                if let data = response.data {
                    SVProgressHUD.toast("Imt.login.success".i18nImt())
                    let json = JSON(data)
                    let loginResult = json["data"]["loginResult"]
                    var user = loginResult["user"]
                    /// 兼容js的处理
                    user["token"] = loginResult["token"]
                    IMSUserManager.shared.setUserInfo(info: user)
                    self.closePage()
                }
            case let .failure(msg, code, error):
                if let code = code, let i18nError = "Imt.error.auth_callback_\(code)".i18nImtWithCheck() {
                    SVProgressHUD.toast(i18nError)
                } else {
                    SVProgressHUD.toast(msg ?? error.localizedDescription)
                }
            }
        }
    }
}

extension IMSLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//            let email = appleIDCredential.email
//            let fullName = appleIDCredential.fullName
            if let identityTokenData = appleIDCredential.authorizationCode,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8)
            {
                Log.d(identityTokenString)
                oauthCallback(type: .apple(identityTokenString))
            }
        } else {
            SVProgressHUD.toast("Error")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        SVProgressHUD.toast(error.localizedDescription)
    }
}

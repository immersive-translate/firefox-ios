// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension IMSOnboardingCardViewController {
    func setupExampleView() {
        imstitleLabel.text = "Imt.Onboarding.TranslateExample.before.title".i18nImt()
        view.addSubview(imstitleLabel)
        
        imsdescriptionLabel.text = "Imt.Onboarding.TranslateExample.before.desc".i18nImt()
        view.addSubview(imsdescriptionLabel)
        
        let primaryAttribute = [
            NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: 0
        ] as [NSAttributedString.Key: Any]
        let primaryAttributeTitle = NSAttributedString(
            string: "Imt.Onboarding.TranslateExample.button".i18nImt(),
            attributes: primaryAttribute
        )
        imsprimaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        imsprimaryButton.backgroundColor = UIColor(hexString: "#CCCCCC")
        imsprimaryButton.isEnabled = false
        view.addSubview(imsprimaryButton);
        
        let secondaryAttribute = [
            NSAttributedString.Key.font: UIFont .systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor(colorString: "999999")
        ]
        let secondaryAttributeTitle = NSAttributedString(
            string: "Imt.Onboarding.TranslateExample.skip".i18nImt(),
            attributes: secondaryAttribute
        )
        imssecondaryButton.setAttributedTitle(secondaryAttributeTitle, for: .normal)
        view.addSubview(imssecondaryButton);
   
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(hexString: "#FAFBFC")
        bgView.layer.cornerRadius = 12
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor(hexString: "#ECF0F7").cgColor
        view.addSubview(bgView)
        
        let titleView = UIView()
        titleView.layer.cornerRadius = 7
        titleView.backgroundColor = UIColor(hexString: "#E0E0E6")
        bgView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(42)
        }
        
        let label = UILabel()
        label.text = "immersivetranslate.com"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#999999")
        titleView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        let imageView = UIImageView(image: UIImage(named: "toolbar_tranlate_setting"))
        titleView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        titleView.addSubview(translateButton)
        translateButton.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(imageView)
            make.right.equalTo(imageView.snp.left).offset(-16)
        }
        
        view.addSubview(translateExampleArrowLottieView)
        translateExampleArrowLottieView.snp.makeConstraints { make in
            make.bottom.equalTo(translateButton.snp.top)
            make.left.equalTo(translateButton.snp.right).offset(-12)
            make.height.equalTo(80)
            make.width.equalTo(80)
        }
        
        
        bgView.addSubview(translateExampleTextView)
        translateExampleTextView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
        }
        
        NSLayoutConstraint.activate([
            imstitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UX.titleLabelTopMargin),
            imstitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            imstitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsdescriptionLabel.topAnchor.constraint(equalTo: imstitleLabel.bottomAnchor, constant: 16),
            imsdescriptionLabel.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imsdescriptionLabel.centerXAnchor.constraint(equalTo: imstitleLabel.centerXAnchor),
            bgView.topAnchor.constraint(equalTo: imsdescriptionLabel.bottomAnchor, constant: 20),
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            bgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bgView.bottomAnchor.constraint(equalTo: imsprimaryButton.topAnchor, constant: -23),
            imssecondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UX.buttonBottomMargin),
            imssecondaryButton.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imssecondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imssecondaryButton.heightAnchor.constraint(equalToConstant: UX.secondaryButtonHeight),
            imsprimaryButton.bottomAnchor.constraint(equalTo: imssecondaryButton.topAnchor, constant: -UX.buttonBottomMargin),
            imsprimaryButton.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imsprimaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsprimaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
        
        view.addSubview(translateExampleFireworksLottieView)
        translateExampleFireworksLottieView.isHidden = true
        translateExampleFireworksLottieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        translateButton.addTarget(self, action: #selector(translateButtonOnClick), for: .touchUpInside)
    }
    
    
    func getExampleData() {
        guard let value = UserDefaults.standard.value(forKey: BusinessJSObject.SelectLanguageKey) as? String else {
            return
        }
        let json = JSON(parseJSON: value)
        let language = json["code"].stringValue
        
        APIService.sendRequest(APPAPI.LoadOnboardingTranslationsRequest(language: language)) { response in
            switch response.result.validateResult {
            case let .success(info):
                self.translateModelArr = info.filter({ $0.key == "welcome_message" })
                self.translateExampleTextView.text = self.translateModelArr.compactMap({ $0.english }).joined(separator: "\n\n")
            case .failure:
                ()
            }
        }
    }
    
    @objc
    private func translateButtonOnClick() {
        translateExampleFireworksLottieView.isHidden = false
        translateExampleTextView.text = self.translateModelArr.compactMap({ $0.english + "\n" + $0.localizedText }).joined(separator: "\n\n")
        translateButton.isEnabled = false
        imsprimaryButton.backgroundColor = UIColor(hexString: "#222222")
        imsprimaryButton.isEnabled = true
        imstitleLabel.text = "Imt.Onboarding.TranslateExample.after.title".i18nImt()
        imsdescriptionLabel.text = "Imt.Onboarding.TranslateExample.after.desc".i18nImt()
        translateExampleArrowLottieView.removeFromSuperview()
        
        translateExampleFireworksLottieView.play { [weak self] completed in
            guard let self = self else { return }
            if completed {
                translateExampleFireworksLottieView.isHidden = true
            }
        }
    }
}

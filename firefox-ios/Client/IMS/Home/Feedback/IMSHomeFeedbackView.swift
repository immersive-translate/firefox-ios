// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

class IMSHomeFeedbackView: UIView {
    private var isOk: Bool?
    
    private lazy var bg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "home_feedback_bg")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var evaluateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(hexString: "#333333")
        label.text = "Imt.home.feedback.title".i18nImt()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var satisfiedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.isHidden = true
        label.textColor = UIColor(hexString: "#333333")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_feedback_delete")
        return imageView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hexString: "#EC4C8C")
        button.setTitle("Imt.Setting.feedback.submit".i18nImt(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(submitButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var gotoButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hexString: "#EC4C8C")
        button.setTitle("Imt.home.feedback.goto".i18nImt(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(gotoButtonOnClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private var currentStarCount: CGFloat = 0
    private lazy var starView: StarRateView = {
        let view = StarRateView(
            frame: CGRect(x: 0, y: 0, width: 146, height: 26),
            totalStarCount: 5,
            currentStarCount: 0,
            starSpace: 4
        )
        view.scoreBlock = {  [weak self] result in
            self?.currentStarCount = result
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(420)
        }
        
        bg.addSubview(evaluateLabel)
        bg.addSubview(satisfiedLabel)
        
        evaluateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-28)
            make.height.greaterThanOrEqualTo(21)
            make.top.equalToSuperview().offset(16)
        }
        
        bg.addSubview(starView)
        starView.snp.makeConstraints { make in
            make.top.equalTo(evaluateLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(starView.frame.width)
            make.height.equalTo(starView.frame.height)
        }
        
        satisfiedLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(25)
        }
        
        bg.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(127)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        bg.addSubview(gotoButton)
        gotoButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(127)
            make.height.equalTo(32)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        bg.addSubview(deleteImageView)
        deleteImageView.addTapGesture { [weak self] _ in
            self?.deleteImageViewOnClick()
        }
        deleteImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.width.height.equalTo(24)
        }
        
    }
}

extension IMSHomeFeedbackView {
    @objc
    private func deleteImageViewOnClick() {
        StoreConfig.alreadyShowFeedbackTip = true
        NotificationCenter.default.post(name: NotificationName.userInfoChange, object: nil)
    }
    
    @objc
    private func submitButtonOnClick() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle
        ]
        if currentStarCount <= 3 {
            satisfiedLabel.isHidden = false
            gotoButton.isHidden = false
            starView.isHidden = true
            starView.isHidden = true
            evaluateLabel.isHidden = true
            submitButton.isHidden = true
            satisfiedLabel.attributedText = NSAttributedString(string: "Imt.home.feedback.dissatisfied.title".i18nImt(), attributes: attributes)
            satisfiedLabel.setNeedsLayout()
            satisfiedLabel.layoutIfNeeded()
            isOk = false
        } else {
            satisfiedLabel.isHidden = false
            gotoButton.isHidden = false
            starView.isHidden = true
            starView.isHidden = true
            evaluateLabel.isHidden = true
            submitButton.isHidden = true
            satisfiedLabel.attributedText = NSAttributedString(string: "Imt.home.feedback.satisfied.title".i18nImt(), attributes: attributes)
            satisfiedLabel.setNeedsLayout()
            satisfiedLabel.layoutIfNeeded()
            isOk = true
        }
    }
    
    @objc
    private func gotoButtonOnClick() {
        if let isOk = isOk {
            if isOk {
                RatingPromptManager.goToAppStoreReview()
            } else {
                let viewController = IMSFeedbackViewController()
                viewController.windowUUID = currentWindowUUID
                RouterManager.shared.present(DismissableNavigationViewController(rootViewController: viewController), animated: true)
            }
            deleteImageViewOnClick()
        }
    }
}

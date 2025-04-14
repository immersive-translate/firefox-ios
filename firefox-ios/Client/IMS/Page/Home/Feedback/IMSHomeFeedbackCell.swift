// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import AttributedString

class IMSHomeFeedbackCell: UICollectionViewCell, ReusableCell {
    var feedbackHandler: (() -> Void)?
    
    private var textColor: UIColor?
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        let press = ASAttributedString.Action(.press, highlights: [.background(.clear)]) { _ in }
        let userClick = ASAttributedString.Action(.click) { [weak self] _ in
            self?.login()
        }
        let message: ASAttributedString = "\("Imt.Setting.home.feedback.button".i18nImt(), .action(press), .action(userClick), .foreground(UIColor(colorString: "00B2F5")), .font(FXFontStyles.Regular.caption1.scaledFont()))"
        label.attributed.text = message
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Imt.Setting.home.feedback.title".i18nImt()
        label.font = FXFontStyles.Regular.caption1.scaledFont()
        label.textColor = UIColor(colorString: "999999")
        return label
    }()
    
    private lazy var titlePinWrapper: UIStackView = .build { stackView in
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        titlePinWrapper.addArrangedSubview(descLabel)
        titlePinWrapper.addArrangedSubview(loginLabel)
        
        contentView.addSubview(titlePinWrapper)
        titlePinWrapper.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    private func login() {
        feedbackHandler?()
    }
}

extension IMSHomeFeedbackCell: ThemeApplicable {
    func applyTheme(theme: Theme) {
//        descLabel.textColor = textColor ?? theme.colors.textPrimary
    }
}

extension IMSHomeFeedbackCell {
    func configure(theme: Theme, textColor: UIColor?) {
        self.textColor = textColor
        applyTheme(theme: theme)
    }
}

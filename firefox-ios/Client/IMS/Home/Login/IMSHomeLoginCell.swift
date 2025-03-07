// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import AttributedString

class IMSHomeLoginCell: UICollectionViewCell, ReusableCell {
    var loginHandler: (() -> Void)?
    
    private var textColor: UIColor?
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        let press = ASAttributedString.Action(.press, highlights: [.background(.clear)]) { _ in }
        let userClick = ASAttributedString.Action(.click) { [weak self] _ in
            self?.login()
        }
        let message: ASAttributedString = "\("Imt.Home.login.action".i18nImt(), .action(press), .action(userClick), .foreground(UIColor(colorString: "EC4C8C")), .font(UIFont.systemFont(ofSize: 14)), .underline(.single))"
        label.attributed.text = message
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Imt.Home.login.desc".i18nImt()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(colorString: "333333")
        return label
    }()
    
    private lazy var titlePinWrapper: UIStackView = .build { stackView in
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        titlePinWrapper.addArrangedSubview(loginLabel)
        titlePinWrapper.addArrangedSubview(descLabel)
        
        contentView.addSubview(titlePinWrapper)
        titlePinWrapper.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    private func login() {
        loginHandler?()
    }
}

extension IMSHomeLoginCell: ThemeApplicable {
    func applyTheme(theme: Theme) {
        descLabel.textColor = textColor ?? theme.colors.textPrimary
    }
}

extension IMSHomeLoginCell {
    func configure(theme: Theme, textColor: UIColor?) {
        self.textColor = textColor
        applyTheme(theme: theme)
    }
}

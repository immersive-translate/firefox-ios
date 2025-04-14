// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

class LoginTypeButton: UIButton {
    var type: LoginType? {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        adjustsImageWhenHighlighted = false
        layer.cornerRadius = 22
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = ThemeColor.TC.FAFBFC.cgColor
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(315)
        }
        backgroundColor = ThemeColor.ZX.FFFFFF
        setTitleColor(ThemeColor.ZX.c333333, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        let spacing: CGFloat = 10
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
    }
    
    private func setupUI() {
        guard let type = type else { return }
        setImage(type.icon, for: .normal)
        setTitle(type.title, for: .normal)
    }
}

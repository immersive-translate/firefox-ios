// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import IQKeyboardToolbar

class InputTextField: UITextField {
    var inputPlaceholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: inputPlaceholder ?? "",
                attributes: [
                    NSAttributedString.Key.foregroundColor: ThemeColor.ZX.CCCCCC,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                ]
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        iq.addDone(target: self, action: #selector(doneAction), title: "")
        layer.borderWidth = 1
        layer.borderColor = ThemeColor.TC.ECF0F7.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
        clipsToBounds = true
        layer.cornerRadius = 8
        font = UIFont.systemFont(ofSize: 14)
        textColor = ThemeColor.ZX.c333333
    }
    
    @objc
    private func doneAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}

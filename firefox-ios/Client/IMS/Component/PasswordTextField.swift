// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

class PasswordTextField: InputTextField {
    private let showHideButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        isSecureTextEntry = true
        showHideButton.setImage(UIImage(named: "password_hidden"), for: .normal)
        showHideButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        showHideButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        rightView = showHideButton
        rightViewMode = .always
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 14
        return rect
    }
    
    @objc
    private func togglePasswordVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "password_hidden" : "password_show"
        showHideButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

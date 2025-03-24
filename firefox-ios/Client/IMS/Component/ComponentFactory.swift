// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import IQKeyboardToolbar

final class ComponentFactory {
    static let shared = ComponentFactory()
    
    private init() {}
}

extension ComponentFactory {
    @MainActor
    func getTextFiled() -> UITextField {
        let textField = UITextField()
        textField.iq.addDone(target: self, action: #selector(doneAction), title: "")
        return textField
    }
    
    @MainActor
    func getTextView() -> UITextView {
        let textView = UITextView()
        textView.iq.addDone(target: self, action: #selector(doneAction), title: "")
        return textView
    }
    
    @objc
    private func doneAction() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}

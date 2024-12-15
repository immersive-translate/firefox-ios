// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

class BusinessJSObject {
    
    public static let SelectLanguageKey = "SelectLanguageKey"

    @objc func getSelectedLanguage( _ params: [String: String]) -> String {
        let value = UserDefaults.standard.value(forKey: BusinessJSObject.SelectLanguageKey) as? String
        return value ?? ""
    }
    
}

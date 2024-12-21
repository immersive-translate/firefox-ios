// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

class BusinessJSObject {
    
    public static let SelectLanguageKey = "SelectLanguageKey"
    
    var shareBlock: (_ params: [String: String]) -> ()
    
    var configDefaultBrowserBlock: () -> ()

    init(shareBlock: @escaping (_ params: [String: String]) -> Void, configDefaultBrowserBlock: @escaping () -> Void) {
        self.shareBlock = shareBlock
        self.configDefaultBrowserBlock = configDefaultBrowserBlock
    }


    @objc func getSelectedLanguage( _ params: [String: String]) -> String {
        let value = UserDefaults.standard.value(forKey: BusinessJSObject.SelectLanguageKey) as? String
        return value ?? ""
    }
    
    @objc func setDefaultBrowser( _ params: [String: String]) -> String {
        self.configDefaultBrowserBlock();
        return ""
    }
    
    @objc func isDefaultBrowser( _ params: [String: String]) -> String {
        return ""
    }
    
    @objc func shareContent( _ params: [String: String]) -> String {
        self.shareBlock(params)
        return ""
    }
    
}

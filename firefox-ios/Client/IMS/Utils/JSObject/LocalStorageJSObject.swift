// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

class LocalStorageJSObject {
    @objc func getItem( _ params: [String: String]) -> String {
       let key = params["key"]!;
       let value = WebLocalStorageManager.shared.string(forKey: key) ?? "";
       return value;
    }
    
    @objc func setItem( _ params: [String: String] ) -> String {
        let key = params["key"]!;
        let value = params["value"]!;
        WebLocalStorageManager.shared.set(String(value), forKey: key)
        return key
    }
    
    @objc func removeItem( _ params: [String: String]) -> String {
        let key = params["key"]!;
        WebLocalStorageManager.shared.removeObject(forKey: key)
        return key
    }
    
    @objc func key( _ params: [String: Int]) -> String {
        let index = params["index"]!;
        return WebLocalStorageManager.shared.key(forIndex: index) ?? "";
    }
    
    @objc func length(_ params: [String: Int]?) -> String {
        return String(WebLocalStorageManager.shared.length());
    }
    
    @objc func clear(_ params: [String: Int]?) -> String {
        WebLocalStorageManager.shared.clear();
        return ""
    }
}
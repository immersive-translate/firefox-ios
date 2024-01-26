// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import WCDBSwift
import Common

final class LocalStorage: TableCodable {
    var key: String? = nil
    var value: String? = nil
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = LocalStorage
        case key
        case value
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(key, isPrimary: true)
        }
    }
}

class LocalStorageManager {
    var tableName = "LocalStorageTable"
    lazy var database: Database = {
        var cachePath = "";
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppInfo.sharedContainerIdentifier) {
            cachePath = containerURL.path;
        } else {
            cachePath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        }
        return Database(at: (cachePath as NSString).appendingPathComponent("cache.db"))
    }()
    
    func set(_ value: String?, forKey key: String) {
        let item = LocalStorage()
        item.key = key;
        item.value = value;
        try? database.insertOrReplace(item, intoTable: tableName)
    }
    
    func removeObject(forKey key: String) {
        try? database.delete(fromTable:  tableName, where: LocalStorage.Properties.key == key)
    }

    func string(forKey key: String) -> String? {
        if let value = try? database.getValue(on: LocalStorage.Properties.value, fromTable: tableName, where: LocalStorage.Properties.key == key) {
            return value.stringValue;
        }
        return nil;
    }
    
    func key(forIndex index: Int) -> String? {
        if let key = try? database.getValue(on: LocalStorage.Properties.key, fromTable: tableName, offset: index) {
            return key.stringValue;
        }
        return nil;
    }
    
    func length() -> Int {
        if let objects: [LocalStorage] = try? database.getObjects(on: LocalStorage.Properties.key, fromTable: tableName) {
            return objects.count;
        }
        return 0;
    }
    
    func clear() -> Void {
        try? database.delete(fromTable: tableName);
    }
}

class WebLocalStorageManager: LocalStorageManager {
    
    public static let shared = WebLocalStorageManager()
    
    override init() {
        super.init();
        tableName = "WebLocalStorage";
        try? database.create(table: tableName, of: LocalStorage.self)
    }
    
}

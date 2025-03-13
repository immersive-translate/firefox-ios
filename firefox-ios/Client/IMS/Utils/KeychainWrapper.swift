// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Common
import Shared
import KeychainAccess


/// 支持存储到 Keychain 的协议
protocol KeychainStoreValue {
    static func from(_ string: String) -> Self?
    var asString: String { get }
}

/// String 支持
extension String: KeychainStoreValue {
    static func from(_ string: String) -> String? { return string }
    var asString: String { return self }
}

/// Int 支持
extension Int: KeychainStoreValue {
    static func from(_ string: String) -> Int? { return Int(string) }
    var asString: String { return String(self) }
}

/// Bool 支持
extension Bool: KeychainStoreValue {
    static func from(_ string: String) -> Bool? { return Bool(string) }
    var asString: String { return String(self) }
}

/// Data 支持
extension Data: KeychainStoreValue {
    static func from(_ string: String) -> Data? { return Data(base64Encoded: string) }
    var asString: String { return self.base64EncodedString() }
}

/// **全局 Keychain 缓存管理**
class KeychainCache {
    static let shared = KeychainCache()

    /// 线程安全的缓存
    private var cache: [String: String] = [:]
    private let queue = DispatchQueue(label: "com.keychain.cache", attributes: .concurrent)

    private init() {}

    /// 读取缓存
    func get(_ key: String) -> String? {
        queue.sync { cache[key] }
    }

    /// 设置缓存
    func set(_ key: String, value: String) {
        queue.async(flags: .barrier) {
            self.cache[key] = value
        }
    }

    /// 移除缓存
    func remove(_ key: String) {
        queue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
        }
    }
}

/// Keychain 存储的 `@propertyWrapper`（支持泛型 + 线程安全缓存）
@propertyWrapper
struct KeychainWrapper<T: KeychainStoreValue> {
    let key: String
    let defaultValue: T
    private let keychain = Keychain(service: AppInfo.bundleIdentifier)

    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            if let cachedValue = KeychainCache.shared.get(key), let typedValue = T.from(cachedValue) {
                return typedValue
            }
            guard let storedValue = try? keychain.get(key), let typedValue = T.from(storedValue) else {
                return defaultValue
            }
            KeychainCache.shared.set(key, value: storedValue)

            return typedValue
        }
        set {
            let stringValue = newValue.asString
            KeychainCache.shared.set(key, value: stringValue)
            try? keychain.set(stringValue, key: key)
        }
    }
}

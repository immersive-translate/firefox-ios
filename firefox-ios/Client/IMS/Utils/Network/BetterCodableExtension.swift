// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import BetterCodable
import Foundation

/**
 Default系列注解是解决当key类型不一致、key名不存在等情况时，解码过程中可以保持一个默认值
 而不会直接解析失败

 @DefaultEmptyArray：空数组
 @DefaultEmptyDictionary：空字典
 @DefaultFalse：默认为false
 @DefaultTrue：默认为true

 @DefaultIntZero：默认为0
 @DefaultDoubleZero：默认为0.0
 @DefaultFloatZero：默认为0.0
 @DefaultEmptyString：空字符串

 Lossy系列是将类型不一致的值默认进行自动转换，如 "true" -> true

 @LossyArray
 @LossyDictionary
 @LosslessValue
 */

public typealias DefaultEmptyArray<T> = DefaultCodable<DefaultEmptyArrayStrategy<T>> where T: Decodable

public typealias DefaultEmptyDictionary<K, V> = DefaultCodable<DefaultEmptyDictionaryStrategy<K, V>> where K: Decodable & Hashable, V: Decodable

public typealias DefaultFalse = DefaultCodable<DefaultFalseStrategy>

public typealias DefaultTrue = DefaultCodable<DefaultTrueStrategy>

/// Double
public struct DefaultDoubleZeroStrategy: DefaultCodableStrategy {
    public static var defaultValue: Double { 0.0 }
}

public typealias DefaultDoubleZero = DefaultCodable<DefaultDoubleZeroStrategy>

/// Float
public struct DefaultFloatZeroStrategy: DefaultCodableStrategy {
    public static var defaultValue: Float { 0.0 }
}

public typealias DefaultFloatZero = DefaultCodable<DefaultFloatZeroStrategy>

/// Int
public struct DefaultIntZeroStrategy: DefaultCodableStrategy {
    public static var defaultValue: Int { 0 }
}

public typealias DefaultIntZero = DefaultCodable<DefaultIntZeroStrategy>

/// 空字符串
public struct DefaultEmptyStringStrategy: DefaultCodableStrategy {
    public static var defaultValue: String { "" }
}

public typealias DefaultEmptyString = DefaultCodable<DefaultEmptyStringStrategy>

// MARK: - enum 使用 Codable 增加默认值

public protocol CodableEnumeration: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get }
}

extension CodableEnumeration {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

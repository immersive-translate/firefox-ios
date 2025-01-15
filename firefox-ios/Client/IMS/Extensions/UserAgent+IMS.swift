// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import WebKit
import UIKit

struct IMSCustomUserAgentConstant {
    private static let defaultMobileUA = UserAgentBuilder.defaultMobileUserAgent().userAgent()
    private static let customDesktopUA = UserAgentBuilder.defaultDesktopUserAgent().clone(extensions: "Version/\(AppInfo.appVersion) \(UserAgent.uaBitSafari)")

    static let customMobileUAForDomain = [
        "paypal.com": defaultMobileUA,
        "yahoo.com": defaultMobileUA,
        "disneyplus.com": customDesktopUA,
        "xiaohongshu.com": customDesktopUA
    ]

    static let customDesktopUAForDomain = [
        "firefox.com": defaultMobileUA
    ]
}

extension UserAgent {
    @_dynamicReplacement(for: uaBitFx)
    public static var ims_uaBitFx: String {
        "ImtFxiOS/\(AppInfo.appVersion)"
    }
    
    @_dynamicReplacement(for: desktopUserAgent)
    public static func ims_desktopUserAgent() -> String {
        var origin = self.desktopUserAgent()
        origin += " FxiOS/\(URL.mozBundleVersion) ImtFxiOS/\(AppInfo.appVersion)"
        return origin
    }
    
    @_dynamicReplacement(for: getUserAgent(domain:platform:))
    public static func ims_getUserAgent(domain: String, platform: UserAgentPlatform) -> String {
        switch platform {
        case .Desktop:
            guard let customUA = IMSCustomUserAgentConstant.customDesktopUAForDomain[domain] else {
                return desktopUserAgent()
            }
            return customUA
        case .Mobile:
            guard let customUA = IMSCustomUserAgentConstant.customMobileUAForDomain[domain] else {
                return mobileUserAgent()
            }
            return customUA
        }
    }
    
    @_dynamicReplacement(for: getUserAgent(domain:))
    public static func ims_getUserAgent(domain: String = "") -> String {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return ims_getUserAgent(domain: domain, platform: .Desktop)
        } else {
            return ims_getUserAgent(domain: domain, platform: .Mobile)
        }
    }
}

extension UserAgentBuilder {
    @_dynamicReplacement(for: defaultMobileUserAgent)
    public static func ims_defaultMobileUserAgent() -> UserAgentBuilder {
        return UserAgentBuilder(
            product: UserAgent.product,
            systemInfo: "(\(UIDevice.current.model); CPU iPhone OS \(UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X)",
            platform: UserAgent.platform,
            platformDetails: UserAgent.platformDetails,
            extensions: "FxiOS/\(URL.mozBundleVersion)  ImtFxiOS/\(AppInfo.appVersion)  \(UserAgent.uaBitMobile) \(UserAgent.uaBitSafari)")
    }
    
    @_dynamicReplacement(for: defaultDesktopUserAgent)
    public static func ims_defaultDesktopUserAgent() -> UserAgentBuilder {
        return UserAgentBuilder(
            product: UserAgent.product,
            systemInfo: "(Macintosh; Intel Mac OS X 10.15)",
            platform: UserAgent.platform,
            platformDetails: UserAgent.platformDetails,
            extensions: "FxiOS/\(URL.mozBundleVersion)  ImtFxiOS/\(AppInfo.appVersion) \(UserAgent.uaBitSafari)")
    }
}

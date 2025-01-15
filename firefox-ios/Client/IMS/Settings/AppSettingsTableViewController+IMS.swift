// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension AppSettingsTableViewController {
    @_dynamicReplacement(for: getAccountSetting)
    func ims_getAccountSetting() -> [SettingSection] {
        guard let userInfo = IMSAccountManager.shard.current() else { return [] }
        var title: String = .FxAFirefoxAccount
        if !userInfo.email.isEmpty {
            title += ": \(userInfo.email)"
        }
        let accountSectionTitle = NSAttributedString(string: .FxAFirefoxAccount)
        return [
            SettingSection(title: accountSectionTitle, children: [
                IMSAccountUpgradeSetting(settingsDelegate: parentCoordinator, userInfo: userInfo)
            ])
        ]
    }
}

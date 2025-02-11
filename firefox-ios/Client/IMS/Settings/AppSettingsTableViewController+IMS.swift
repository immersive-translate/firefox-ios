// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension AppSettingsTableViewController {
    @_dynamicReplacement(for: getAccountSetting)
    func ims_getAccountSetting() -> [SettingSection] {
        return []
    }
    
    @_dynamicReplacement(for: getSupportSettings)
    func ims_getSupportSettings() -> [SettingSection] {
        var supportSettings = [
            ShowIntroductionSetting(settings: self, settingsDelegate: self),
            SendFeedbackSetting(settingsDelegate: parentCoordinator),
            AbountAppSetting(settingsDelegate: parentCoordinator),
        ]
        
        return [SettingSection(title: NSAttributedString(string: .AppSettingsSupport),
                               children: supportSettings)]
        
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
class AbountAppSetting: Setting {
    private weak var settingsDelegate: AboutSettingsDelegate?
    override var accessoryView: UIImageView? {
        guard let theme else { return nil }
        return SettingDisclosureUtility.buildDisclosureIndicator(theme: theme)
    }
    override var accessibilityIdentifier: String? {
        return AccessibilityIdentifiers.Settings.AboutApp.title
    }
    override var style: UITableViewCell.CellStyle { return .value1 }
    override var title: NSAttributedString? {
        guard let theme else { return nil }
        return NSAttributedString(string: .SettingsAbountAppSectionName,
                                  attributes: [NSAttributedString.Key.foregroundColor: theme.colors.textPrimary])
    }
    
    init(settingsDelegate: AboutSettingsDelegate?) {
        self.settingsDelegate = settingsDelegate
        super.init(title: nil)
    }
    override func onClick(_ navigationController: UINavigationController?) {
        settingsDelegate?.pressedAboutApp()
    }
}

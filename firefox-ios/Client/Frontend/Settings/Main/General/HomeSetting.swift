// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Shared

class HomeSetting: Setting {
    private weak var settingsDelegate: GeneralSettingsDelegate?
    private let profile: Profile

    override var accessoryView: UIImageView? {
        return SettingDisclosureUtility.buildDisclosureIndicator(theme: theme)
    }

    override var accessibilityIdentifier: String? {
        return AccessibilityIdentifiers.Settings.Homepage.homeSettings
    }

    override var status: NSAttributedString {
        let prefs = self.profile.prefs.stringForKey(PrefsKeys.UserFeatureFlagPrefs.StartAtHome) ?? StartAtHomeSetting.disabled.rawValue
        var title:String = "";
        switch prefs {
        case StartAtHomeSetting.disabled.rawValue:
            title = .Settings.Homepage.StartAtHome.Never;
        case StartAtHomeSetting.afterFourHours.rawValue:
            title = .Settings.Homepage.StartAtHome.AfterFourHours;
        default:
            title = .Settings.Homepage.StartAtHome.Always;
        }
        return NSAttributedString(string: title)
    }

    override var style: UITableViewCell.CellStyle { return .value1 }

    init(settings: SettingsTableViewController,
         settingsDelegate: GeneralSettingsDelegate?) {
        self.profile = settings.profile
        self.settingsDelegate = settingsDelegate
        let theme = settings.themeManager.getCurrentTheme(for: settings.windowUUID)
        super.init(
            title: NSAttributedString(
                string: .SettingsHomePageSectionName,
                attributes: [
                    NSAttributedString.Key.foregroundColor: theme.colors.textPrimary
                ]
            )
        )
    }

    override func onClick(_ navigationController: UINavigationController?) {
        settingsDelegate?.pressedHome()
    }
}

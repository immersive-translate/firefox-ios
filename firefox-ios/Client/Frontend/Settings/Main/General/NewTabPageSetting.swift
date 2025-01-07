// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Shared

class NewTabPageSetting: Setting {
    private let profile: Profile
    private weak var settingsDelegate: GeneralSettingsDelegate?

    override var accessoryView: UIImageView? {
        return SettingDisclosureUtility.buildDisclosureIndicator(theme: theme)
    }

    override var accessibilityIdentifier: String? {
        return AccessibilityIdentifiers.Settings.NewTab.title
    }

    override var status: NSAttributedString {
        let prefs = self.profile.prefs.stringForKey(NewTabAccessors.NewTabPrefKey) ?? NewTabPage.topSites.rawValue
        var title:String = "";
        switch prefs {
        case NewTabPage.blankPage.rawValue:
            title = .SettingsNewTabBlankPage;
        case NewTabPage.homePage.rawValue:
            title = .SettingsNewTabCustom;
        default:
            title = .SettingsNewTabTopSites;
        }
        return NSAttributedString(string: title)
//        return NSAttributedString(string: NewTabAccessors.getNewTabPage(self.profile.prefs).settingTitle)
    }

    override var style: UITableViewCell.CellStyle { return .value1 }

    init(settings: SettingsTableViewController,
         settingsDelegate: GeneralSettingsDelegate?) {
        self.profile = settings.profile
        self.settingsDelegate = settingsDelegate
        let theme = settings.themeManager.getCurrentTheme(for: settings.windowUUID)
        super.init(
            title: NSAttributedString(
                string: .SettingsNewTabSectionName,
                attributes: [
                    NSAttributedString.Key.foregroundColor: theme.colors.textPrimary
                ]
            )
        )
    }

    override func onClick(_ navigationController: UINavigationController?) {
        settingsDelegate?.pressedNewTab()
    }
}

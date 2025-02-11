// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


protocol IMSAccountSettingDelegate: AnyObject {
    func pressedIMSAccountUpgrade(userInfo: IMSAccountInfo?)
}

class IMSAccountUpgradeSetting: Setting {
    let userInfo: IMSAccountInfo?
    private weak var settingsDelegate: IMSAccountSettingDelegate?
    
    override var accessoryView: UIImageView? {
        guard let theme else { return nil }
        return SettingDisclosureUtility.buildDisclosureIndicator(theme: theme)
    }
    
    override var title: NSAttributedString? {
        guard let theme else { return nil }
        return NSAttributedString(string: .IMS.Settings.Upgrade,
                                  attributes: [NSAttributedString.Key.foregroundColor: theme.colors.textPrimary])
    }
    
    init(settingsDelegate: IMSAccountSettingDelegate?, userInfo: IMSAccountInfo?) {
        self.settingsDelegate = settingsDelegate
        self.userInfo = userInfo
        super.init(title: nil)
    }
    
    override func onClick(_ navigationController: UINavigationController?) {
        settingsDelegate?.pressedIMSAccountUpgrade(userInfo: userInfo)
    }
    
}

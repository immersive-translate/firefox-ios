// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared

class TutorialsSetting: Setting {
    private weak var settingsDelegate: AboutSettingsDelegate?

    override var url: URL? {
        return URL(string: IMSAppUrlConfig.usage)
    }

    init(theme: Theme,
         settingsDelegate: AboutSettingsDelegate?) {
        self.settingsDelegate = settingsDelegate
        super.init(title: NSAttributedString(string: .IMS.ImmersiveTranslateTutorials,
                                             attributes: [NSAttributedString.Key.foregroundColor: theme.colors.textPrimary]))
    }

    override func onClick(_ navigationController: UINavigationController?) {
        guard let url = self.url,
              let title = self.title else { return }
        settingsDelegate?.pressedTutorials(url: url, title: title)
        return
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Shared

class IMSFeedbackViewController: UIViewController {
    var windowUUID: WindowUUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let themeManager: ThemeManager = AppContainer.shared.resolve()
        view.backgroundColor = themeManager.getCurrentTheme(for: windowUUID).colors.layer1
        title = "Imt.Setting.menu.feedback".i18nImt()
    }
}

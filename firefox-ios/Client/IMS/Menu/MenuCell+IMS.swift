// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import Common
import UIKit
import MenuKit

extension MenuCell {
    @_dynamicReplacement(for: configureCellWith(model:))
    public func ims_configureCellWith(model: MenuElement) {
        self.configureCellWith(model: model)
        guard model.title == .IMS.Settings.Upgrade ||
              model.title == .IMS.IMTSetting
        else {
            return
        }
        self.icon.image = UIImage(named: model.iconName)
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import ComponentLibrary

extension HeaderView {
    @_dynamicReplacement(for: setupViews)
    func ims_setupViews() {
        self.setupViews()
        self.headerLabelsContainer.isHidden = true
        self.mainButton.isHidden = true
        self.mainButton.isUserInteractionEnabled = false
        self.favicon.isHidden = true
        self.iconMask.isHidden = true
    }
}

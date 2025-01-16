// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension TabTrayViewController {
    @_dynamicReplacement(for: segmentControlItems)
    var ims_segmentControlItems: [Any] {
        let iPhoneItems = [
            TabTrayPanelType.tabs.image!.overlayWith(image: countLabel),
            TabTrayPanelType.privateTabs.image!]
        return isRegularLayout ? [TabTrayPanelType.tabs, TabTrayPanelType.privateTabs].map { $0.label } : iPhoneItems
    }
}

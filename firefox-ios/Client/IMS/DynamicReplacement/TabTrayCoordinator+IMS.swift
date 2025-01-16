// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension TabTrayCoordinator {
    @_dynamicReplacement(for: makeChildPanels)
    func ims_makeChildPanels() -> [UINavigationController] {
        let origin = self.makeChildPanels().filter { !($0.viewControllers.first is RemoteTabsPanel) }
        return origin
    }
}

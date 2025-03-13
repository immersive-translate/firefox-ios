// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Shared

extension HomepageViewModel {
    @_dynamicReplacement(for: beforeInit)
    func ims_beforeInit() {
        let topSiteViewModel = IMSTopSitesViewModel(profile: profile, theme: theme, wallpaperManager: wallpaperManager)
        self.childViewModels.insert(topSiteViewModel, at: 2)
        let loginViewModel = IMSHomeLoginCellViewModel(theme: theme, wallpaperManager: wallpaperManager)
        self.childViewModels.insert(loginViewModel, at: 3)
        let feedbackModel = IMSHomeFeedbackCellViewModel(theme: theme, wallpaperManager: wallpaperManager)
        self.childViewModels.append(feedbackModel)
    }
}

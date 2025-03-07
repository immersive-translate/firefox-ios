// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension LegacyHomepageViewController {
    @_dynamicReplacement(for: setupSectionsAction)
    func ims_setupSectionsAction() {
        self.setupSectionsAction()
        if let viewModel =  self.viewModel.childViewModels[2] as? IMSTopSitesViewModel {
            viewModel.tilePressedHandler = { [weak self] site, isGoogle in
                guard let url = site.url.asURL else { return }
                self?.showSiteWithURLHandler(url, isGoogleTopSite: isGoogle)
            }
        }
        if let viewModel = self.viewModel.childViewModels[3] as? IMSHomeLoginCellViewModel {
            viewModel.loginHandler = { [weak self] in
                guard let self = self else { return }
                guard let url = URL(string: IMSAppUrlConfig.login + "?app_action=gotoUpgrade") else { return }
                showSiteWithURLHandler(url, isGoogleTopSite: false)
            }
        }
    }
}

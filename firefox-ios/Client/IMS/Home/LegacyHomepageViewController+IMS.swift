// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension LegacyHomepageViewController {
    @_dynamicReplacement(for: setupSectionsAction)
    func ims_setupSectionsAction() {
        self.setupSectionsAction()
        initNotificationCenter()
        if let viewModel =  self.viewModel.childViewModels[2] as? IMSTopSitesViewModel {
            viewModel.tilePressedHandler = { [weak self] site, isGoogle in
                guard let url = site.url.asURL else { return }
                self?.showSiteWithURLHandler(url, isGoogleTopSite: isGoogle)
            }
        }
        if let viewModel = self.viewModel.childViewModels[3] as? IMSHomeLoginCellViewModel {
            viewModel.loginHandler = { [weak self] in
                guard let self = self else { return }
                guard let url = URL(string: IMSAppUrlConfig.login) else { return }
                showSiteWithURLHandler(url, isGoogleTopSite: false)
            }
        }
        if let viewModel = self.viewModel.childViewModels[self.viewModel.childViewModels.count - 1] as? IMSHomeFeedbackCellViewModel {
            viewModel.feedbackHandler = { [weak self] in
                guard let self = self else { return }
                let viewController = IMSFeedbackViewController()
                viewController.windowUUID = self.windowUUID
                RouterManager.shared.present(DismissableNavigationViewController(rootViewController: viewController), animated: true)
            }
        }
    }
    
    private func initNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowHomepageNotification(_:)), name: .ShowHomepage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserInfoChangeNotification(_:)), name: NotificationName.userInfoChange, object: nil)
    }
    
    @objc
    private func handleUserInfoChangeNotification(_ notification: Notification) {
        reloadView()
    }
    
    @objc
    private func handleShowHomepageNotification(_ notification: Notification) {
        Task {
            let localUserInfo = IMSAccountManager.shard.current()
            if let token = localUserInfo?.token {
                if let userInfoAsync = try await IMSIAPHttpService.getUserInfo(token: token) {
//                    let userInfo = IMSAccountInfo.from(token: token, resp: userInfoAsync.data)
//                    if let jsonData = try? JSONEncoder().encode(userInfo),
//                       let jsonString = String(data: jsonData, encoding: .utf8) {
//                        WebLocalStorageManager.shared.set(jsonString, forKey: IMSAccountConfig.localStoreKey)
//                    }
                } else {
                    WebLocalStorageManager.shared.removeObject(forKey: IMSAccountConfig.localStoreKey)
                    await MainActor.run {
                        reloadView()
                    }
                }
            }
        }
    }
}

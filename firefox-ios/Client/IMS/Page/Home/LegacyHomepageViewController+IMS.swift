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
                if site.id == 1 {
                    let viewController = IMSWebExampleViewController()
                    viewController.callback = { urlStr in
                        if let url = URL(string: urlStr) {
                            self?.showSiteWithURLHandler(url, isGoogleTopSite: isGoogle)
                        }
                    }
                    RouterManager.shared.pushViewController(viewController, animated: true)
                } else if site.id == 2 {
                    let viewController = IMSVideoExampleViewController()
                    viewController.callback = { urlStr in
                        if let url = URL(string: urlStr) {
                            self?.showSiteWithURLHandler(url, isGoogleTopSite: isGoogle)
                        }
                    }
                    RouterManager.shared.pushViewController(viewController, animated: true)
                } else {
                    self?.showSiteWithURLHandler(url, isGoogleTopSite: isGoogle)
                }
                switch site.id {
                case 1:
                    TrackManager.shared.event("Homepage_Web_Click")
                case 2:
                    TrackManager.shared.event("Homepage_Video_Click")
                case 3:
                    TrackManager.shared.event("Homepage_Doc_Click")
                case 4:
                    TrackManager.shared.event("Homepage_Manga_Click")
                case 6:
                    TrackManager.shared.event("Homepage_Rednote_Click")
                case 7:
                    TrackManager.shared.event("Homepage_Bilin_Click")
                default:
                    ()
                }
            }
        }
        if let viewModel = self.viewModel.childViewModels[4] as? IMSHomeLoginCellViewModel {
            viewModel.loginHandler = { [weak self] in
                guard let self = self else { return }
                let viewController = IMSLoginViewController()
                RouterManager.shared.pushViewController(viewController, animated: true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleHomeFeedbackChangeNotification(_:)), name: NotificationName.homeFeedbackChange, object: nil)
    }
    
    @objc
    private func handleUserInfoChangeNotification(_ notification: Notification) {
        reloadView()
    }
    
    @objc
    private func handleHomeFeedbackChangeNotification(_ notification: Notification) {
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

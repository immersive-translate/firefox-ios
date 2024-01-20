// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import Shared

class AbountAppViewController: SettingsTableViewController, AppSettingsScreen {
    var parentCoordinator: SettingsFlowDelegate?
    
    init(prefs: Prefs) {
        super.init(style: .plain)
        self.title = .SettingsAbountAppSectionName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func generateSettings() -> [SettingSection] {
        var settings = [Setting]()
        settings += [
            PrivacyPolicySetting(theme: themeManager.currentTheme, settingsDelegate: parentCoordinator),
            SendAnonymousUsageDataSetting(prefs: profile.prefs,
                                          delegate: settingsDelegate,
                                          theme: themeManager.currentTheme,
                                          settingsDelegate: parentCoordinator),
            StudiesToggleSetting(prefs: profile.prefs,
                                 delegate: settingsDelegate,
                                 theme: themeManager.currentTheme,
                                 settingsDelegate: parentCoordinator),
            OpenSupportPageSetting(delegate: settingsDelegate,
                                   theme: themeManager.currentTheme,
                                   settingsDelegate: parentCoordinator),
            TutorialsSetting(theme: themeManager.currentTheme, settingsDelegate: parentCoordinator),
            AppStoreReviewSetting(settingsDelegate: parentCoordinator),
            LicenseAndAcknowledgementsSetting(settingsDelegate: parentCoordinator),
            YourRightsSetting(settingsDelegate: parentCoordinator),
        ]
        let section = SettingSection(
            title: nil,
            footerTitle: nil,
            children: settings)

        return [section]
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView();
    }
    
    // MARK: Handle Route decisions

    func handle(route: Route.SettingsSection) {

    }
    
    func headerView() -> UIView {
        let containerView = UIView()
        containerView.frame = CGRectMake(0, 0, tableView.frame.size.width, 200)
        let appView = UIView()
        containerView.addSubview(appView)
        
        let logoImageViewHeight = 60.0;
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(imageLiteralResourceName: ImageIdentifiers.homeHeaderLogoBall)
//        logoImageView.layer.cornerRadius = logoImageViewHeight / 2;
        logoImageView.layer.masksToBounds = true;
        appView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let nameLabel = UILabel()
        nameLabel.text = AppInfo.displayName;
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        appView.addSubview(nameLabel)
        
        appView.translatesAutoresizingMaskIntoConstraints = false
        
        let descLabel = UILabel()
        if AppInfo.isChinaEdition {
            descLabel.text = "沉浸式翻译浏览器是⼀款基于⽕狐浏览器技术的定制产品，由沉浸式翻译团队独⽴开发。⽕狐浏览器是Mozilla的⼀个开源项⽬"
        } else {
            descLabel.text = "Immersive Translate Browser is a customized product developed independently by Immersive Translate team, based on the technology of the Firefox browser, an open-source project by Mozilla."
        }
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.textColor = UIColor.black
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.textAlignment = .center
        containerView.addSubview(descLabel)
        
        
        let fireFoxLabel = UILabel()
//        fireFoxLabel.text = "\n";
        fireFoxLabel.numberOfLines = 0
        fireFoxLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fireFoxLabel.textColor = UIColor.black
        fireFoxLabel.translatesAutoresizingMaskIntoConstraints = false
        fireFoxLabel.textAlignment = .center;
        containerView.addSubview(fireFoxLabel)

        NSLayoutConstraint.activate([
            appView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            appView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            logoImageView.leftAnchor.constraint(equalTo: appView.leftAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: logoImageViewHeight),
            logoImageView.heightAnchor.constraint(equalToConstant: logoImageViewHeight),
            logoImageView.bottomAnchor.constraint(equalTo: appView.bottomAnchor),
            logoImageView.topAnchor.constraint(equalTo: appView.topAnchor),

            nameLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: appView.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: appView.rightAnchor),
            
            descLabel.topAnchor.constraint(equalTo: appView.bottomAnchor, constant: 20),
            descLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            descLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 45),

            fireFoxLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10),
            fireFoxLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            fireFoxLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
//            fireFoxLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)

        ])
        
        return containerView
    }
}

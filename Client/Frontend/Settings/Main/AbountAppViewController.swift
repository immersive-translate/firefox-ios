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
        let headerView = headerView();
        tableView.tableHeaderView = headerView;
    }
    
    // MARK: Handle Route decisions

    func handle(route: Route.SettingsSection) {

    }
    
    func headerView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        let appView = UIView()
        containerView.addSubview(appView)
        
        let textColor = themeManager.currentTheme.colors.textPrimary;
        
        let logoImageViewHeight = 60.0;
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(imageLiteralResourceName: ImageIdentifiers.homeHeaderLogoBall)
        logoImageView.layer.masksToBounds = true;
        appView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let nameLabel = UILabel()
        nameLabel.text = AppInfo.displayName;
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = textColor
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
        descLabel.textColor = textColor
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.textAlignment = .center
        containerView.addSubview(descLabel)
        
        
        let plugLabel = UILabel()
        plugLabel.text = "Immersive Translate version: \(PlugInUpdateManager.shared.currentVersion)";
        plugLabel.font = UIFont.systemFont(ofSize: 16)
        plugLabel.textColor = textColor
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        plugLabel.textAlignment = .center;
        containerView.addSubview(plugLabel)
        
        let appLabel = UILabel()
        appLabel.text = "APP Version: \(AppInfo.appVersion)";
        appLabel.font = UIFont.systemFont(ofSize: 16)
        appLabel.textColor = textColor
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.textAlignment = .center;
        containerView.addSubview(appLabel)
        
        
        let fireFoxLabel = UILabel()
        fireFoxLabel.text = "Firefox Version: 122.0";
        fireFoxLabel.font = UIFont.systemFont(ofSize: 16)
        fireFoxLabel.textColor = textColor
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

            plugLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 6),
            plugLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            plugLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
            
            appLabel.topAnchor.constraint(equalTo: plugLabel.bottomAnchor, constant: 6),
            appLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            appLabel.leftAnchor.constraint(equalTo: descLabel.leftAnchor),
            
            fireFoxLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 10),
            fireFoxLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            fireFoxLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            fireFoxLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            fireFoxLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        ])
        
        let size = containerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        containerView.frame = CGRectMake(0, 0, UIScreen.main.bounds.size.width, size.height)
        return containerView
    }
}
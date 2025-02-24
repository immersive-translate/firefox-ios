// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import Shared

class AbountAppViewController: SettingsTableViewController, AppSettingsScreen, FeatureFlaggable {
    var parentCoordinator: SettingsFlowDelegate?
    var prefs: Prefs
    
    init(prefs: Prefs, windowUUID: WindowUUID) {
        self.prefs = prefs
        super.init(style: .plain, windowUUID: windowUUID)
        self.title = .SettingsAbountAppSectionName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func generateSettings() -> [SettingSection] {
        let isTermsOfServiceFeatureEnabled = featureFlags.isFeatureEnabled(.tosFeature, checking: .buildOnly)
        
        var settings = [Setting]()
        let currentTheme = themeManager.getCurrentTheme(for: windowUUID)
        
        let studiesSetting = StudiesToggleSetting(
            prefs: prefs,
            delegate: settingsDelegate,
            theme: themeManager.getCurrentTheme(for: windowUUID),
            settingsDelegate: parentCoordinator,
            title: isTermsOfServiceFeatureEnabled ? .StudiesSettingTitleV2 : .SettingsStudiesToggleTitle,
            message: isTermsOfServiceFeatureEnabled ? .StudiesSettingMessageV2 : .SettingsStudiesToggleMessage,
            linkedText: isTermsOfServiceFeatureEnabled ? .StudiesSettingLinkV2 : .SettingsStudiesToggleLink,
            isToSEnabled: isTermsOfServiceFeatureEnabled
        )
        
        let sendAnonymousUsageDataSettings = SendDataSetting(
            prefs: prefs,
            delegate: settingsDelegate,
            theme: themeManager.getCurrentTheme(for: windowUUID),
            settingsDelegate: parentCoordinator,
            title: .SendUsageSettingTitle,
            message: String(format: .SendUsageSettingMessage,
                            MozillaName.shortName.rawValue,
                            AppName.shortName.rawValue),
            linkedText: .SendUsageSettingLink,
            prefKey: AppConstants.prefSendUsageData,
            a11yId: AccessibilityIdentifiers.Settings.SendData.sendAnonymousUsageDataTitle,
            learnMoreURL: SupportUtils.URLForTopic("adjust"),
            isToSEnabled: isTermsOfServiceFeatureEnabled
        )

        sendAnonymousUsageDataSettings.shouldSendData = { [weak self] value in
            guard let self, let profile = self.profile else { return }
            TermsOfServiceManager(prefs: profile.prefs).shouldSendTechnicalData(value: value)
            studiesSetting.updateSetting(for: value)
        }
        
        settings += [
            PrivacyPolicySetting(theme: currentTheme, settingsDelegate: parentCoordinator),
            sendAnonymousUsageDataSettings,
            studiesSetting,
            OpenSupportPageSetting(delegate: settingsDelegate,
                                   theme: currentTheme,
                                   settingsDelegate: parentCoordinator),
            TutorialsSetting(theme: currentTheme, settingsDelegate: parentCoordinator),
            AppStoreReviewSetting(settingsDelegate: parentCoordinator),
            LicenseAndAcknowledgementsSetting(settingsDelegate: parentCoordinator),
            YourRightsSetting(settingsDelegate: parentCoordinator),
            IMSTermsofServiceSetting(theme: currentTheme, settingsDelegate: parentCoordinator),
            IMSPrivacyPolicySetting(theme: currentTheme, settingsDelegate: parentCoordinator),
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
        
        let textColor = themeManager.getCurrentTheme(for: windowUUID).colors.textPrimary;
        
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
        descLabel.text = .ImtLocalizableAppInfo
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.textColor = textColor
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.textAlignment = .center
        containerView.addSubview(descLabel)
        
        
        let versionText:String = .ImtLocalizableVersion
        let appText:String = .ImtLocalizableApp

        let plugLabel = UILabel()
        plugLabel.text = "\(AppInfo.displayName) \(versionText): \(PlugInUpdateManager.shared.currentVersion)";
        plugLabel.font = UIFont.systemFont(ofSize: 16)
        plugLabel.textColor = textColor
        plugLabel.translatesAutoresizingMaskIntoConstraints = false
        plugLabel.textAlignment = .center;
        containerView.addSubview(plugLabel)
        
        let appLabel = UILabel()
        appLabel.text = "\(appText) \(versionText): \(AppInfo.appVersion)";
        appLabel.font = UIFont.systemFont(ofSize: 16)
        appLabel.textColor = textColor
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.textAlignment = .center;
        containerView.addSubview(appLabel)
        
        
        let fireFoxLabel = UILabel()
        fireFoxLabel.text = "Firefox \(versionText): \(URL.mozBundleVersion)";
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

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import MenuKit
import Shared

extension MainMenuActionHelper {
    @_dynamicReplacement(for: getLibrarySection)
    func ims_getLibrarySection() -> [PhotonRowActions] {
        var section = self.getLibrarySection()
        let imtSettingAction = getImtSettingAction()
        section.append(imtSettingAction)
        return section
    }
    
    @_dynamicReplacement(for: syncMenuButton)
    func ims_syncMenuButton() -> PhotonRowActions? {
        return nil
    }
    
    private func getImtSettingAction() -> PhotonRowActions {
        return SingleActionViewModel(title: .LegacyAppMenu.IMTSetting,
                                     iconString: StandardImageIdentifiers.Large.settings) { _ in
            if let url = URL(string: IMSAppUrlConfig.dash) {
                self.delegate?.openURLInNewTab(url, isPrivate: false)
            }
            TelemetryWrapper.recordEvent(category: .action, method: .tap, object: .imtSettings)
        }.items
    }
    
    @_dynamicReplacement(for: getHelpAction)
    func ims_getHelpAction() -> PhotonRowActions {
        return SingleActionViewModel(title: .LegacyAppMenu.Help,
                                     iconString: StandardImageIdentifiers.Large.helpCircle) { _ in
            if let url = URL(string: IMSAppUrlConfig.usage) {
                self.delegate?.openURLInNewTab(url, isPrivate: self.tabManager.selectedTab?.isPrivate ?? false)
            }
            TelemetryWrapper.recordEvent(category: .action, method: .tap, object: .help)
        }.items
    }
}

extension MainMenuConfigurationUtility {
    @_dynamicReplacement(for: getMainMenuElements(with:and:))
    func ims_getMainMenuElements(
        with uuid: WindowUUID,
        and tabInfo: MainMenuTabInfo
    ) -> [MenuSection] {
        var menuSections = self.getMainMenuElements(with: uuid, and: tabInfo)
        let imtSettingAction = MenuElement(
            title: .LegacyAppMenu.IMTSetting,
            iconName: StandardImageIdentifiers.Large.settings,
            isEnabled: true,
            isActive: false,
            a11yLabel: "",
            a11yHint: "",
            a11yId: "",
            action: {
                store.dispatch(
                    MainMenuAction(
                        windowUUID: uuid,
                        actionType: MainMenuActionType.tapNavigateToDestination,
                        navigationDestination: MenuNavigationDestination(
                            .goToURL,
                            url: URL(string: IMSAppUrlConfig.dash)
                        ),
                        telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                    )
                )
            }
        )
        
        let imsUpgradeSettingAction = MenuElement(
            title: .IMS.Settings.Upgrade,
            // replace this iconName,
            iconName: "upgrade-menu-icon",
            isEnabled: true,
            isActive: false,
            a11yLabel: "",
            a11yHint: "",
            a11yId: "",
            action: {
                imsStore.dispatch(
                    IMSMainMenuAction(
                        windowUUID: uuid,
                        actionType: MainMenuActionType.tapNavigateToDestination,
                        navigationDestination: .upgrade,
                        telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                    )
                )
            }
        )
        
        let imsMenuSection = MenuSection(options: [
            imtSettingAction,
            imsUpgradeSettingAction,
        ])
        if menuSections.count > 1 {
            menuSections.insert(imsMenuSection, at: 1)
        } else {
            menuSections.append(imsMenuSection)
        }
        
        return menuSections
        
    }
    @_dynamicReplacement(for: getOtherToolsSection(with:isHomepage:tabInfo:))
    func ims_getOtherToolsSection(
        with uuid: WindowUUID,
        isHomepage: Bool,
        tabInfo: MainMenuTabInfo
    ) -> MenuSection {
        
        let homepageOptions = [
            MenuElement(
                title: .MainMenu.OtherToolsSection.CustomizeHomepage,
                iconName: StandardImageIdentifiers.Large.gridAdd,
                isEnabled: true,
                isActive: false,
                a11yLabel: .MainMenu.OtherToolsSection.AccessibilityLabels.CustomizeHomepage,
                a11yHint: "",
                a11yId: AccessibilityIdentifiers.MainMenu.customizeHomepage,
                action: {
                    store.dispatch(
                        MainMenuAction(
                            windowUUID: uuid,
                            actionType: MainMenuActionType.tapNavigateToDestination,
                            navigationDestination: MenuNavigationDestination(.customizeHomepage),
                            telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                        )
                    )
                }
            ),
            MenuElement(
                title: .LegacyAppMenu.WhatsNewString,
                iconName: StandardImageIdentifiers.Large.whatsNew,
                isEnabled: true,
                isActive: false,
                a11yLabel: String(
                    format: .MainMenu.OtherToolsSection.AccessibilityLabels.WhatsNew,
                    AppName.shortName.rawValue
                ),
                a11yHint: "",
                a11yId: AccessibilityIdentifiers.MainMenu.whatsNew,
                action: {
                    store.dispatch(
                        MainMenuAction(
                            windowUUID: uuid,
                            actionType: MainMenuActionType.tapNavigateToDestination,
                            navigationDestination: MenuNavigationDestination(
                                .goToURL,
                                url: URL(string: IMSAppUrlConfig.changelog)
                            ),
                            telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                        )
                    )
                }
            ),
        ]

        let standardOptions = [
            MenuElement(
                title: .LegacyAppMenu.Help,
                iconName: StandardImageIdentifiers.Large.helpCircle,
                isEnabled: true,
                isActive: false,
                a11yLabel: "",
                a11yHint: "",
                a11yId: "",
                action: {
                    store.dispatch(
                        MainMenuAction(
                            windowUUID: uuid,
                            actionType: MainMenuActionType.tapNavigateToDestination,
                            navigationDestination: MenuNavigationDestination(
                                .goToURL,
                                url: URL(string: IMSAppUrlConfig.usage)
                            ),
                            telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                        )
                    )
                }
            ),
            MenuElement(
                title: .MainMenu.OtherToolsSection.Settings,
                iconName: StandardImageIdentifiers.Large.settings,
                isEnabled: true,
                isActive: false,
                a11yLabel: .MainMenu.OtherToolsSection.AccessibilityLabels.Settings,
                a11yHint: "",
                a11yId: AccessibilityIdentifiers.MainMenu.settings,
                action: {
                    store.dispatch(
                        MainMenuAction(
                            windowUUID: uuid,
                            actionType: MainMenuActionType.tapNavigateToDestination,
                            navigationDestination: MenuNavigationDestination(.settings),
                            telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                        )
                    )
                }
            ),
        ]

        return MenuSection(options: isHomepage ? homepageOptions + standardOptions : standardOptions)
    }
}

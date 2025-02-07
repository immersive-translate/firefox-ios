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
            if let url = URL(string: "https://dash.immersivetranslate.com/") {
                self.delegate?.openURLInNewTab(url, isPrivate: false)
            }
            TelemetryWrapper.recordEvent(category: .action, method: .tap, object: .imtSettings)
        }.items
    }
    
    @_dynamicReplacement(for: getHelpAction)
    func ims_getHelpAction() -> PhotonRowActions {
        return SingleActionViewModel(title: .LegacyAppMenu.Help,
                                     iconString: StandardImageIdentifiers.Large.helpCircle) { _ in
            if let url = URL(string: "https://immersivetranslate.com/docs/usage/") {
                self.delegate?.openURLInNewTab(url, isPrivate: self.tabManager.selectedTab?.isPrivate ?? false)
            }
            TelemetryWrapper.recordEvent(category: .action, method: .tap, object: .help)
        }.items
    }
}

extension MainMenuConfigurationUtility {
    @_dynamicReplacement(for: getLibrariesSection(with:tabInfo:))
    func ims_getLibrariesSection(with uuid: WindowUUID, tabInfo: MainMenuTabInfo) -> MenuSection {
        let origin = self.getLibrariesSection(with: uuid, tabInfo: tabInfo)
        var options = origin.options
        
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
                            url: URL(string: "https://dash.immersivetranslate.com/")
                        ),
                        telemetryInfo: TelemetryInfo(isHomepage: tabInfo.isHomepage)
                    )
                )
            }
        )
        
        options.append(imtSettingAction)
        
        return MenuSection(options: options)
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
                                url: URL(string: "https://immersivetranslate.com/docs/CHANGELOG/")
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
                                url: URL(string: "https://immersivetranslate.com/docs/usage/")
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

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Redux
import Common

extension MainMenuViewController {
    
    @_dynamicReplacement(for: newState(state:))
    func ims_newState(state: MainMenuState) {
        if let imsMainMenuState = state.imsMainMenuState,
           let navigationDestination = imsMainMenuState.navigationDestination{
            self.coordinator?.navigateTo(navigationDestination, animated: true)
        } else {
            self.newState(state: state)
        }
        
    }
}

enum IMSMainMenuNavigationDestination: Equatable, CaseIterable {
    case upgrade
}

final class IMSMainMenuAction: Action {
    var tabID: TabUUID?
    var navigationDestination: IMSMainMenuNavigationDestination?
    var currentTabInfo: MainMenuTabInfo?
    var detailsViewToShow: MainMenuDetailsViewType?
    var accountData: AccountData?
    var accountIcon: UIImage?
    var telemetryInfo: TelemetryInfo?

    init(
        windowUUID: WindowUUID,
        actionType: any ActionType,
        navigationDestination: IMSMainMenuNavigationDestination? = nil,
        changeMenuViewTo: MainMenuDetailsViewType? = nil,
        currentTabInfo: MainMenuTabInfo? = nil,
        tabID: TabUUID? = nil,
        accountData: AccountData? = nil,
        accountIcon: UIImage? = nil,
        telemetryInfo: TelemetryInfo? = nil
    ) {
        self.navigationDestination = navigationDestination
        self.detailsViewToShow = changeMenuViewTo
        self.currentTabInfo = currentTabInfo
        self.tabID = tabID
        self.accountData = accountData
        self.accountIcon = accountIcon
        self.telemetryInfo = telemetryInfo
        super.init(windowUUID: windowUUID, actionType: actionType)
    }
}

struct IMSMainMenuState: Equatable {
    var windowUUID: WindowUUID
    var navigationDestination: IMSMainMenuNavigationDestination?
    
    init(appState: AppState, uuid: WindowUUID) {
        self.init(windowUUID: uuid)
    }
    
    init(windowUUID: WindowUUID, navigationDestination: IMSMainMenuNavigationDestination? = nil) {
        self.windowUUID = windowUUID
        self.navigationDestination = navigationDestination
    }
    
    static let reducer: Reducer<Self?> = { state, action in
        guard action.windowUUID == .unavailable || action.windowUUID == state?.windowUUID,
            let state = state
        else {
            return nil
        }
        switch action.actionType {
        case MainMenuActionType.tapNavigateToDestination:
            guard let action = action as? IMSMainMenuAction else { return nil }
            return IMSMainMenuState(
                windowUUID: state.windowUUID,
                navigationDestination: action.navigationDestination
            )
        default:
            return nil
        }
        
    }
}



extension MainMenuCoordinator {
    func navigateTo(_ destination: IMSMainMenuNavigationDestination, animated: Bool) {
        router.dismiss(animated: animated, completion: { [weak self] in
            guard let self else { return }
            switch destination {
            case .upgrade:
                self.showIMSUpgrade()
            }
            
        })
    }
    
    func showIMSUpgrade() {
        let viewController = IMSAccountUpgradeViewController(userInfo: nil, windowUUID: windowUUID)
//        router.push(viewController, animated: true)
        self.navigationHandler?.showCustomViewController(vc: viewController)
        
    }
}

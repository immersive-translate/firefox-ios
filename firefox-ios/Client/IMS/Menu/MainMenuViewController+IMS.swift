// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Redux
import Common

extension MainMenuViewController {
    
    struct IMSMainMenuViewControllerAssociatedKeys {
        static var imsMainMenuKey: UInt8 = 0
    }
    
    var imsMainMenuController: IMSMainMenuController? {
        get {
            objc_getAssociatedObject(self, &IMSMainMenuViewControllerAssociatedKeys.imsMainMenuKey) as? IMSMainMenuController
        }
        set {
            objc_setAssociatedObject(self, &IMSMainMenuViewControllerAssociatedKeys.imsMainMenuKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    @_dynamicReplacement(for: subscribeToRedux)
    func ims_subscribeToRedux() {
        self.subscribeToRedux()
        if self.imsMainMenuController == nil {
            self.imsMainMenuController = IMSMainMenuController(windowUUID: windowUUID, parentMenuViewController: self)
        }
        self.imsMainMenuController?.subscribeToRedux()
    }
}

class IMSMainMenuController: StoreSubscriber {
    var windowUUID: WindowUUID
    weak var parentMenuViewController: MainMenuViewController?
    
    init(windowUUID: WindowUUID, parentMenuViewController: MainMenuViewController?) {
        self.windowUUID = windowUUID
        self.parentMenuViewController = parentMenuViewController
    }
    
    deinit {
        self.unsubscribeFromRedux()
    }
    
    func subscribeToRedux() {
        imsStore.dispatch(
            IMSScreenAction(
                windowUUID: windowUUID,
                actionType: ScreenActionType.showScreen,
                screen: .mainMenu
            )
        )
        let uuid = windowUUID
        imsStore.subscribe(self, transform: {
            return $0.select({ appState in
                return IMSMainMenuState(appState: appState, uuid: uuid)
            })
        })
    }
    
    func unsubscribeFromRedux() {
        imsStore.dispatch(
            IMSScreenAction(
                windowUUID: windowUUID,
                actionType: ScreenActionType.closeScreen,
                screen: .mainMenu
            )
        )
    }
    
    func newState(state: IMSMainMenuState) {
        if let navigationDestination = state.navigationDestination {
            self.parentMenuViewController?.coordinator?.navigateTo(navigationDestination, animated: true)
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

struct IMSMainMenuState: IMSScreenState, Equatable {
    var windowUUID: WindowUUID
    var navigationDestination: IMSMainMenuNavigationDestination?
    
    init(appState: IMSAppState, uuid: WindowUUID) {
        guard let mainMenuState = imsStore.state.screenState(IMSMainMenuState.self, for: .mainMenu, window: uuid) else {
            self.init(windowUUID: uuid)
            return
        }
        self.init(windowUUID: uuid, navigationDestination: mainMenuState.navigationDestination)
    }
    
    init(windowUUID: WindowUUID, navigationDestination: IMSMainMenuNavigationDestination? = nil) {
        self.windowUUID = windowUUID
        self.navigationDestination = navigationDestination
    }
    
    static let reducer: Reducer<Self> = { state, action in
        guard action.windowUUID == .unavailable || action.windowUUID == state.windowUUID
        else {
            return defaultState(from: state)
        }
        switch action.actionType {
        case MainMenuActionType.tapNavigateToDestination:
            guard let action = action as? IMSMainMenuAction else { return defaultState(from: state) }
            return IMSMainMenuState(
                windowUUID: state.windowUUID,
                navigationDestination: action.navigationDestination
            )
        default:
            return defaultState(from: state)
        }
        
    }
    
    static func defaultState(from state: IMSMainMenuState) -> IMSMainMenuState {
        return IMSMainMenuState(windowUUID: state.windowUUID, navigationDestination: nil)
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
        let browserViewController = self.navigationHandler?.getBrowserViewController()
        browserViewController?.showIMSUpgradeViewController()
        
    }
}

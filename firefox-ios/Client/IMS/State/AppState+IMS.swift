// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Redux
import Common

class IMSScreenAction: Action {
    let screen: IMSAppScreen

    init(windowUUID: WindowUUID,
         actionType: ActionType,
         screen: IMSAppScreen) {
        self.screen = screen
        super.init(windowUUID: windowUUID,
                   actionType: actionType)
    }
}

enum IMSAppScreen {
    case mainMenu
}

protocol IMSScreenState: StateType {
    var windowUUID: WindowUUID { get }
}


enum IMSAppScreenState: Equatable {
    case mainMenu(IMSMainMenuState)
    
    static let reducer: Reducer<Self> = { state, action in
        switch state {
        case .mainMenu(let state):
            return .mainMenu(IMSMainMenuState.reducer(state, action))
        }
        
    }
    
    var associatedAppScreen: IMSAppScreen {
        switch self {
        case .mainMenu(_):
            return .mainMenu
        }
    }
    
    var windowUUID: WindowUUID? {
        switch self {
        case .mainMenu(let state):
            return state.windowUUID
        }
    }
}

struct IMSAppState: StateType {
    let screens: [IMSAppScreenState]
    
    init() {
        self.screens = []
    }
    
    init(screens: [IMSAppScreenState]) {
        self.screens = screens
    }
    
    func screenState<S: IMSScreenState>(_ s: S.Type,
                                     for screen: IMSAppScreen,
                                     window: WindowUUID?) -> S? {
        return screens
            .compactMap {
                switch ($0, screen) {
                case (.mainMenu(let state), .mainMenu): return state as? S
                }
            }.first(where: {
                // Most screens should be filtered based on the specific identifying UUID.
                // This is necessary to allow us to have more than 1 of the same type of
                // screen in Redux at the same time. If no UUID is provided we return `first`.
                guard let expectedUUID = window else { return true }
                // Generally this should be considered a code smell, attempting to select the
                // screen for an .unavailable window is nonsensical and may indicate a bug.
                guard expectedUUID != .unavailable else { return true }

                return $0.windowUUID == expectedUUID
            })
    }
    
    static func defaultState(from state: IMSAppState) -> IMSAppState {
        return IMSAppState(screens: state.screens)
    }
    
    
    
    static let reducer: Reducer<Self> = { state, action in
        var screens = updateActiveScreens(action: action, screens: state.screens)
        
        screens = screens.map { IMSAppScreenState.reducer($0, action) }
        
        return IMSAppState(screens: screens)
    }
    
    private static func updateActiveScreens(action: Action, screens: [IMSAppScreenState]) -> [IMSAppScreenState] {
        guard let action = action as? IMSScreenAction else { return screens }
        
        var screens = screens
        switch action.actionType {
        case ScreenActionType.closeScreen:
            screens = screens.filter({
                return $0.associatedAppScreen != action.screen || $0.windowUUID != action.windowUUID
            })
        case ScreenActionType.showScreen:
            let uuid = action.windowUUID
            switch action.screen {
            case .mainMenu:
                screens.append(.mainMenu(IMSMainMenuState(windowUUID: uuid)))
            }
        default:
            return screens    
        }
        
        return screens
    }
}

let imsStore: any DefaultDispatchStore<IMSAppState> = Store(state: IMSAppState(),
                                                      reducer: IMSAppState.reducer)

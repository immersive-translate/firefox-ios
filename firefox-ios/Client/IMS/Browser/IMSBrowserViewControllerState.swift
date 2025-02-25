// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Redux
import Shared
import Common
import WebKit

enum IMSTranslatePageBrowserActionType: ActionType {
    case none
    case translatePage
    case restorePage
    case togglePopup
}

class IMSTranslatePageBrowserAction: Action {
    let selectedTabURL: URL?
    
    init(selectedTabURL: URL?,
         windowUUID: WindowUUID,
         actionType: ActionType) {
        self.selectedTabURL = selectedTabURL
        super.init(windowUUID: windowUUID,
                   actionType: actionType)
    }
}


struct IMSBrowserViewControllerState: IMSScreenState, Equatable {
    var windowUUID: WindowUUID
    var pageStatus: String?
    var actionType: IMSTranslatePageBrowserActionType?
    
    init(appState: IMSAppState, uuid: WindowUUID) {
        guard let oldState = imsStore.state.screenState(
            IMSBrowserViewControllerState.self,
            for: .browserViewController,
            window: uuid)
        else {
            self.init(windowUUID: uuid)
            return
        }
        self.init(windowUUID: oldState.windowUUID, pageStatus: oldState.pageStatus, actionType: oldState.actionType)
        
    }
    
    init(windowUUID: WindowUUID, pageStatus: String? = nil, actionType: IMSTranslatePageBrowserActionType? = nil) {
        self.windowUUID = windowUUID
        self.pageStatus = pageStatus
        self.actionType = actionType
    }
    
    static let reducer: Reducer<Self> = { state, action in
        guard action.windowUUID == .unavailable || action.windowUUID == state.windowUUID
        else {
            return defaultState(from: state)
        }
        if let action = action as? IMSTranslatePageBrowserAction, let actionType = action.actionType as? IMSTranslatePageBrowserActionType {
            return IMSBrowserViewControllerState(windowUUID: state.windowUUID, actionType: actionType)
        }
        
        return defaultState(from: state)
    }
    
    static func defaultState(from state: IMSBrowserViewControllerState) -> IMSBrowserViewControllerState {
        return .init(windowUUID: state.windowUUID, pageStatus: state.pageStatus, actionType: state.actionType)
    }
}

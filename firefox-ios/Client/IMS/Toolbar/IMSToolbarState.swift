// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Redux
import ToolbarKit

struct IMSToolbarState: IMSScreenState, Equatable {
    var windowUUID: WindowUUID
    var pageStatus: String?
    
    init(appState: IMSAppState, uuid: WindowUUID) {
        guard let toolbarState = imsStore.state.screenState(
            IMSToolbarState.self,
            for: .toolbar,
            window: uuid)
        else {
            self.init(windowUUID: uuid)
            return
        }
        self.init(windowUUID: toolbarState.windowUUID, pageStatus: toolbarState.pageStatus)
        
    }
    
    init(windowUUID: WindowUUID, pageStatus: String? = nil) {
        self.windowUUID = windowUUID
        self.pageStatus = pageStatus
    }
    
    static let reducer: Reducer<Self> = { state, action in
        guard action.windowUUID == .unavailable || action.windowUUID == state.windowUUID
        else {
            return defaultState(from: state)
        }
        
        return defaultState(from: state)
    }
    
    static func defaultState(from state: IMSToolbarState) -> IMSToolbarState {
        return .init(windowUUID: state.windowUUID, pageStatus: state.pageStatus)
    }
    
}

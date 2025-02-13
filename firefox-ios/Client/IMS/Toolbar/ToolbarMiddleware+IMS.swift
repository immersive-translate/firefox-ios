// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Redux
import ToolbarKit

extension ToolbarMiddleware {
    @_dynamicReplacement(for: handleToolbarButtonTapActions(action:state:))
    func ims_handleToolbarButtonTapActions(action: ToolbarMiddlewareAction, state: AppState) {
        
        if case .qrCode = action.buttonType,
           let _ = state.screenState(ToolbarState.self, for: .toolbar, window: action.windowUUID) {
            store.dispatch(
                HeaderAction(
                    windowUUID: action.windowUUID,
                    actionType: HeaderActionType.toggleHomepageMode
                )
            )
        } else {
            self.handleToolbarButtonTapActions(action: action, state: state)
        }
    }
}

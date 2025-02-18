// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Redux
import ToolbarKit


extension AddressBarState {
    private static let privCodeScanAction = ToolbarActionState(
        actionType: .qrCode,
        iconName: StandardImageIdentifiers.Large.privateMode,
        isEnabled: true,
        a11yLabel: .TabTrayToggleAccessibilityLabel,
        a11yId: AccessibilityIdentifiers.FirefoxHomepage.OtherButtons.privateModeToggleButton)
    
    @_dynamicReplacement(for: handleDidLoadToolbarsAction(state:action:))
    static func ims_handleDidLoadToolbarsAction(state: Self, action: Action) -> Self {
        guard let borderPosition = (action as? ToolbarAction)?.addressBorderPosition else {
            return defaultState(from: state)
        }
        var state = self.handleDidLoadToolbarsAction(state: state, action: action)
        state.pageActions = [privCodeScanAction]
        return state
    }
    
    @_dynamicReplacement(for: pageActions(action:addressBarState:isEditing:showQRPageAction:))
    static func ims_pageActions(
        action: ToolbarAction,
        addressBarState: AddressBarState,
        isEditing: Bool,
        showQRPageAction: Bool? = nil
    ) -> [ToolbarActionState] {
        let showQrCodeButton = showQRPageAction ?? addressBarState.showQRPageAction

        guard !showQrCodeButton else {
            // On homepage we only show the QR code button
            return [privCodeScanAction]
        }
        return self.pageActions(action: action, addressBarState: addressBarState, isEditing: isEditing, showQRPageAction: showQRPageAction)
        
    }
}

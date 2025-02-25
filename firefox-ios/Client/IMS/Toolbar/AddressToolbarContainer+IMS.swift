// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Redux
import ToolbarKit
import UIKit

extension AddressToolbarContainer {
    
    struct IMSAssociatedKeys {
        static var controllerKey: UInt8 = 0
    }
    
    var imsController: AddressToolbarContainerController? {
        get {
            objc_getAssociatedObject(self, &IMSAssociatedKeys.controllerKey) as? AddressToolbarContainerController
        }
        set {
            objc_setAssociatedObject(self, &IMSAssociatedKeys.controllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @_dynamicReplacement(for: subscribeToRedux)
    func ims_subscribeToRedux() {
        self.subscribeToRedux()
        guard let windowUUID else { return }
        if (imsController == nil) {
            imsController = AddressToolbarContainerController(windowUUID: windowUUID, parent: self)
            imsController?.subscribeToRedux()
        }
    }
    
    @_dynamicReplacement(for: updateModel(toolbarState:))
    func ims_updateModel(toolbarState: ToolbarState) {
        let preModel = self.model
        self.updateModel(toolbarState: toolbarState)
        guard let windowUUID, let profile else { return }
        let newModel = AddressToolbarContainerModel(state: toolbarState,
                                                    profile: profile,
                                                    windowUUID: windowUUID)
        if preModel != newModel {
            let addressToolbarState = self.imsController?.getAddressToolbarState(model: newModel) ?? newModel.addressToolbarState
            compactToolbar.configure(state: addressToolbarState,
                                     toolbarDelegate: self,
                                     leadingSpace: calculateToolbarSpace(),
                                     trailingSpace: calculateToolbarSpace(),
                                     isUnifiedSearchEnabled: isUnifiedSearchEnabled)
            regularToolbar.configure(state: addressToolbarState,
                                     toolbarDelegate: self,
                                     leadingSpace: calculateToolbarSpace(),
                                     trailingSpace: calculateToolbarSpace(),
                                     isUnifiedSearchEnabled: isUnifiedSearchEnabled)
        }
    }
    
    
    
    class AddressToolbarContainerController: StoreSubscriber {
        
        let windowUUID: WindowUUID
        weak var parent: AddressToolbarContainer?
        var pageStatus: IMSToolbarTranslateActionType?
        
        init(windowUUID: WindowUUID, parent: AddressToolbarContainer) {
            self.windowUUID = windowUUID
            self.parent = parent
        }
        
        func subscribeToRedux() {
            imsStore.dispatch(
                IMSScreenAction(
                    windowUUID: windowUUID,
                    actionType: ScreenActionType.showScreen,
                    screen: .toolbar
                )
            )
            let uuid = windowUUID
            imsStore.subscribe(self, transform: {
                return $0.select({ appState in
                    return IMSToolbarState(appState: appState, uuid: uuid)
                })
            })
        }
        
        func newState(state: IMSToolbarState) {
            self.pageStatus = state.pageStatus
            guard let _ = state.pageStatus,
                  let parent = parent,
                  let newModel = parent.model
            else { return }
            
            let addressToolbarState = self.getAddressToolbarState(model: newModel)
            
            parent.compactToolbar.configure(state: addressToolbarState,
                                     toolbarDelegate: parent,
                                            leadingSpace: parent.calculateToolbarSpace(),
                                            trailingSpace: parent.calculateToolbarSpace(),
                                            isUnifiedSearchEnabled: parent.isUnifiedSearchEnabled)
            parent.regularToolbar.configure(state: addressToolbarState,
                                     toolbarDelegate: parent,
                                            leadingSpace: parent.calculateToolbarSpace(),
                                            trailingSpace: parent.calculateToolbarSpace(),
                                            isUnifiedSearchEnabled: parent.isUnifiedSearchEnabled)
        }
        
        func unsubscribeFromRedux() {
            imsStore.dispatch(
                IMSScreenAction(
                    windowUUID: windowUUID,
                    actionType: ScreenActionType.closeScreen,
                    screen: .toolbar
                )
            )
        }
        
        func getAddressToolbarState(model: AddressToolbarContainerModel) -> AddressToolbarState {
            let currentState = model.addressToolbarState
            
            var pageActions: [ToolbarElement] = []
            
            if currentState.locationViewState.isEditing {
                pageActions = []
            } else {
                if currentState.locationViewState.url == nil {
                    pageActions.append(ToolbarElement(iconName: StandardImageIdentifiers.Large.privateMode, isEnabled: true, a11yLabel: .TabTrayToggleAccessibilityLabel, a11yHint: nil, a11yId: AccessibilityIdentifiers.FirefoxHomepage.OtherButtons.privateModeToggleButton, hasLongPressAction: false, onSelected: { btn in
                        store.dispatch(
                            HeaderAction(
                                windowUUID: model.windowUUID,
                                actionType: HeaderActionType.toggleHomepageMode
                            )
                        )
                    }))
                } else {
                    if self.pageStatus == .translated {
                        pageActions.append(ToolbarElement(iconName: "toolbar_tranlate_active", isEnabled: true, a11yLabel: .TabTrayToggleAccessibilityLabel, a11yHint: nil, a11yId: "toolbar_tranlate_active", hasLongPressAction: false, onSelected: { btn in
                            
                            imsStore.dispatch(
                                IMSTranslatePageBrowserAction(
                                    selectedTabURL: currentState.locationViewState.url,
                                    windowUUID: model.windowUUID,
                                    actionType: IMSTranslatePageBrowserActionType.restorePage
                                )
                            )
                        }))
                    } else {
                        pageActions.append(ToolbarElement(iconName: "toolbar_tranlate_normal", isEnabled: true, a11yLabel: .TabTrayToggleAccessibilityLabel, a11yHint: nil, a11yId: "toolbar_tranlate_normal", hasLongPressAction: false, onSelected: { btn in
                            
                            imsStore.dispatch(
                                IMSTranslatePageBrowserAction(
                                    selectedTabURL: currentState.locationViewState.url,
                                    windowUUID: model.windowUUID,
                                    actionType: IMSTranslatePageBrowserActionType.translatePage
                                )
                            )
                        }))
                    }
                    pageActions.append(ToolbarElement(iconName: "toolbar_tranlate_setting", isEnabled: true, a11yLabel: .TabTrayToggleAccessibilityLabel, a11yHint: nil, a11yId: "toolbar_tranlate_setting", hasLongPressAction: false, onSelected: { btn in
                        imsStore.dispatch(
                            IMSTranslatePageBrowserAction(
                                selectedTabURL: currentState.locationViewState.url,
                                windowUUID: model.windowUUID,
                                actionType: IMSTranslatePageBrowserActionType.togglePopup
                            )
                        )
                    }))
                    if let reloadAction = currentState.pageActions.first(where: {
                        $0.iconName == StandardImageIdentifiers.Large.cross ||
                        $0.iconName == StandardImageIdentifiers.Large.arrowClockwise
                    }) {
                        pageActions.append(reloadAction)
                    }
                }
            }
            
            return AddressToolbarState(locationViewState: currentState.locationViewState, navigationActions: currentState.navigationActions, pageActions: pageActions, browserActions: currentState.browserActions, borderPosition: currentState.borderPosition)
        }
        
        deinit {
            unsubscribeFromRedux()
        }
    }
}

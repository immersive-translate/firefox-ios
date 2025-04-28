// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import UIKit
import ToolbarKit

extension Notification.Name {
    static let imsShowToolbarTranslateTip: Notification.Name = .init("imsShowToolbarTranslateTip")
    static let imsShowToolbarTranslateFeedbackTip: Notification.Name = .init("imsShowToolbarFeedbackTip")
    static let imsShowToolbarTranslateSettingTip: Notification.Name = .init("imsShowToolbarTranslateSettingTip")
}

extension ToolbarKit.ToolbarButton {
    struct IMSAssociatedKeys {
        static var controllerKey: UInt8 = 0
    }
    
    var toolbarElement: ToolbarElement? {
        get {
            objc_getAssociatedObject(self, &IMSAssociatedKeys.controllerKey) as? ToolbarElement
        }
        set {
            objc_setAssociatedObject(self, &IMSAssociatedKeys.controllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @_dynamicReplacement(for: configure(element:))
    func ims_configure(element: ToolbarElement) {
        self.configure(element: element)
        if element.iconName == "toolbar_tranlate_normal" {
            NotificationCenter.default.addObserver(forName: .imsShowToolbarTranslateTip, object: nil, queue: .main) {[weak self] ntf in
                self?.showToolBarPopover(title: String.IMS.ToolbarTip.clickTranslateCurrentPage, btnTitle: String.IMS.ToolbarTip.ihadKnown, onClose: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        NotificationCenter.default.post(name: .imsShowToolbarTranslateFeedbackTip, object: ntf.object)
                    }
                })
            }
        } else if element.iconName == "toolbar_tranlate_setting" {
            NotificationCenter.default.addObserver(forName: .imsShowToolbarTranslateSettingTip, object: nil, queue: .main) {[weak self] ntf in
                self?.showToolBarPopover(title: String.IMS.ToolbarTip.clickTranslateCurrentPanel, btnTitle: "Imt.Toolbar.Tip.clickTranslateCurrentPanel.try".i18nImt(), onClose: {
                    if let object = ntf.object as? [String: Any], let url = object["url"] as? URL, let uuid = object["uuid"] as? WindowUUID {
                        imsStore.dispatch(
                            IMSTranslatePageBrowserAction(
                                selectedTabURL: url,
                                windowUUID: uuid,
                                actionType: IMSTranslatePageBrowserActionType.togglePopup
                            )
                        )
                    }
                })
            }
        } else if element.iconName == "toolbar_feedback" {
            NotificationCenter.default.addObserver(forName: .imsShowToolbarTranslateFeedbackTip, object: nil, queue: .main) {[weak self] ntf in
                self?.showToolBarPopover(title: "Imt.Toolbar.Tip.clickFeedbackPanel".i18nImt(), btnTitle: String.IMS.ToolbarTip.ihadKnown, onClose: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        NotificationCenter.default.post(name: .imsShowToolbarTranslateSettingTip, object: ntf.object)
                    }
                })
            }
        }
    }
    
    @_dynamicReplacement(for: imageConfiguredForRTL(for:))
    func ims_imageConfiguredForRTL(for element: ToolbarElement) -> UIImage? {
        self.toolbarElement = element
        let image = if element.iconName == "toolbar_tranlate_active" {
            UIImage(named: element.iconName)
        } else {
            UIImage(named: element.iconName)?.withRenderingMode(.alwaysTemplate)
        }
        return element.isFlippedForRTL ? image?.imageFlippedForRightToLeftLayoutDirection() : image
    }
    @_dynamicReplacement(for: applyTheme(theme:))
    public func ims_applyTheme(theme: Theme) {
        self.applyTheme(theme: theme)
        guard let toolbarElement = toolbarElement,
              toolbarElement.iconName == "toolbar_tranlate_active"
        else { return }
        if theme.type == .dark || theme.type == .nightMode {
            configuration?.image = UIImage(named: "toolbar_tranlate_active_dark")
        } else {
            configuration?.image = UIImage(named: "toolbar_tranlate_active")
        }
    }
}

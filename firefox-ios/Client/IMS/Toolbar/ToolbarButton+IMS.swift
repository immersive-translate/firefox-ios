// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import UIKit
import ToolbarKit

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

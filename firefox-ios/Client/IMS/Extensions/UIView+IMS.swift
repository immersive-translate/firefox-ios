// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

@IBDesignable
extension UIView {
    // 圆角半径
    @IBInspectable var ims_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            setNeedsDisplay()
        }
    }
    
    // 边框宽度
    @IBInspectable var ims_borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
    }
    
    // 边框颜色
    @IBInspectable var ims_borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
    }
    
    // 可选：添加准备渲染的方法
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

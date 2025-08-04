//
//  NCAlertAction.swift
//  PhotonCity
//
//  Created by yuanchao on 2022/7/9.
//

import Foundation

open class NCAlertAction: NSObject {
    /// 标题
    open private(set) var title: String?

    /// action样式
    open private(set) var style: Style = .default

    /// action回调
    open internal(set) var handler: ((NCAlertAction) -> Void)?

    /// 点击Action按钮后是否移除alertView ，如果设为false,需要手动移除
    open var dismissWhenClickAction = true

    /// Action是否可点击，如果为false，按钮样式为不可点击状态，且点击无反应
    open var isEnabled = true {
        didSet {
            if isEnabled != oldValue {
                observablePropertyChanged?()
            }
        }
    }

    var observablePropertyChanged: (() -> Void)?

    public convenience init(title: String?, style: Style, handler: ((NCAlertAction) -> Void)? = nil) {
        self.init()

        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension NCAlertAction {
    public enum Style: Int {
        case `default` = 0
        case cancel = 1
        case destructive = 2
        case destructiveCavity = 3
    }
}

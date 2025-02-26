// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

extension UIViewController {
    struct IMSAssociatedKeys {
        static var controllerKey: UInt8 = 0
    }

    var imsPopoverDelegate: DefaultPopoverDelegate? {
        get {
            objc_getAssociatedObject(self, &IMSAssociatedKeys.controllerKey)
                as? DefaultPopoverDelegate
        }
        set {
            objc_setAssociatedObject(
                self, &IMSAssociatedKeys.controllerKey, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 默认的Popover代理，确保在iPhone上也显示为popover
    class DefaultPopoverDelegate: NSObject,UIPopoverPresentationControllerDelegate {

        var onClose: (() -> Void)?

        init(onClose: (() -> Void)? = nil) {
            self.onClose = onClose
            super.init()
            print("DefaultPopoverDelegate: init: \(self)")
        }

        // 强制使用 popover 样式
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        // 处理 popover 消失
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {

            self.onClose?()
        }
        
        func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
            self.onClose?()
        }
        
        deinit {
            print("DefaultPopoverDelegate: deinit: \(self)")
        }
    }
}

extension UIView {

    /// 从当前视图显示一个popover
    /// - Parameters:
    ///   - contentViewController: 要在popover中显示的视图控制器
    ///   - sourceRect: popover箭头指向的区域，默认为整个视图
    ///   - arrowDirections: 允许的箭头方向，默认为任意方向
    ///   - completion: 显示完成后的回调
    func showPopover(
        with contentViewController: UIViewController,
        sourceRect: CGRect? = nil,
        arrowDirections: UIPopoverArrowDirection = .any,
        delegate: UIPopoverPresentationControllerDelegate? = nil,
        completion: (() -> Void)? = nil,
        onClose: (() -> Void)? = nil
    ) {
        // 确保我们能找到当前视图所在的视图控制器
        guard let parentViewController = findViewController() else {
            print("无法找到当前视图所属的视图控制器")
            return
        }

        // 设置popover样式
        contentViewController.modalPresentationStyle = .popover

        // 配置popoverPresentationController
        if let popoverPC = contentViewController.popoverPresentationController {
            popoverPC.sourceView = self
            popoverPC.sourceRect = sourceRect ?? bounds
            popoverPC.permittedArrowDirections = arrowDirections

            // 如果提供了代理，则使用提供的代理
            // 否则使用默认代理确保在iPhone上也显示为popover
            if let delegate = delegate {
                popoverPC.delegate = delegate
            } else {
                if contentViewController.imsPopoverDelegate == nil {
                    contentViewController.imsPopoverDelegate = UIViewController.DefaultPopoverDelegate(onClose: onClose)
                }
                popoverPC.delegate = contentViewController.imsPopoverDelegate
            }
            // 显示popover
            parentViewController.present(contentViewController, animated: true, completion: completion)
        }
    }

    /// 查找当前视图所属的视图控制器
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}


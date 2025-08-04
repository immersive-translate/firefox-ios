//
//  UIView+dialog.swift
//  PhotonCity
//
//  Created by yuanchao on 2022/7/10.
//

public protocol DialogBase: NSObject {
    associatedtype DialogExtensionBase

    var dialog: DialogExtension<DialogExtensionBase> { get set }
}

public struct DialogExtension<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

extension UIView: DialogBase {
    public var dialog: DialogExtension<UIView> {
        get { DialogExtension(self) }
        set {}
    }
}

private var dialogWindowKey: Void?
private var dialogMaskViewKey: Void?

extension DialogExtension where Base: UIView {
    public var dismissByTouchOutsideContent: Bool {
        set {
            if maskView == nil {
                maskView = MaskView(contentView: base)
            }
            (maskView as? MaskView)?.dismissByTouchOutsideContent = newValue
        }
        get {
            if let maskView = maskView as? MaskView {
                return maskView.dismissByTouchOutsideContent
            }
            return false
        }
    }

    public func showInCenter(in view: UIView? = nil, animated: Bool = true, duration: TimeInterval = 0.25, backgroundOpacity: CGFloat = 0.37, completion: (() -> Void)? = nil) {
        let show = {
            if !animated {
                completion?()
                return
            }

            let view = base.superview
            view?.backgroundColor = UIColor.black.withDarkColor(.white).withAlphaComponent(0)
            base.alpha = 0
            UIView.animate(withDuration: duration) {
                view?.backgroundColor = ThemeColor.c333333.withAlphaComponent(backgroundOpacity).withDarkColor(UIColor.black.withAlphaComponent(0.59))
                self.base.alpha = 1
            } completion: { _ in
                completion?()
            }
        }

        if maskView == nil {
            let maskView = MaskView(contentView: base)
            base.dialog.maskView = maskView
        }
        (maskView as? MaskView)?.dismissAnimation = { dismissInCenter() }
        maskView?.backgroundColor = ThemeColor.c333333.withDarkColor(.white).withAlphaComponent(backgroundOpacity)

        guard let view = view else {
            showInWindow(showAnimation: { show() }, dismissAnimation: { dismissInCenter() })
            return
        }

        view.addSubview(maskView!)
        maskView?.frame = view.bounds
        base.center = CGPoint(x: view.tx.width / 2, y: view.tx.height / 2)

        show()
    }

    public func dismissInCenter(animated: Bool = true, duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        if !animated {
            base.removeFromSuperview()
            destroyWindow()
            base.dialog.maskView = nil
            completion?()
            return
        }

        UIView.animate(withDuration: duration) {
            self.base.superview?.backgroundColor = UIColor.black.withDarkColor(.white).withAlphaComponent(0)
            self.base.alpha = 0
        } completion: { _ in
            self.base.removeFromSuperview()
            self.base.dialog.maskView = nil
            self.destroyWindow()
            completion?()
        }
    }

    public func showInBottom(in view: UIView? = nil, animated: Bool = true, duration: TimeInterval = 0.25, backgroundOpacity: CGFloat = 0.37, completion: (() -> Void)? = nil) {
        let show = {
            if !animated {
                completion?()
                return
            }

            guard let view = base.superview else { return }
            base.tx.y = view.tx.height
            view.backgroundColor = UIColor.black.withDarkColor(.white).withAlphaComponent(0)
            UIView.animate(withDuration: duration) {
                view.backgroundColor = ThemeColor.c333333.withDarkColor(.white).withAlphaComponent(backgroundOpacity)
                base.tx.y = view.tx.height - base.tx.height
            } completion: { _ in
                completion?()
            }
        }

        if maskView == nil {
            let maskView = MaskView(contentView: base, dismissAnimation: { dismissInBottom() })
            base.dialog.maskView = maskView
            maskView.dismissByTouchOutsideContent = dismissByTouchOutsideContent
        }
        base.dialog.maskView?.backgroundColor = ThemeColor.c333333.withDarkColor(.white).withAlphaComponent(backgroundOpacity)

        guard let view = view else {
            showInWindow(showAnimation: { show() }, dismissAnimation: { dismissInBottom() })
            return
        }

        view.addSubview(maskView!)
        maskView?.frame = view.bounds
        base.tx.bottom = view.tx.height

        show()
    }

    public func dismissInBottom(animated: Bool = true, duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        if !animated {
            base.removeFromSuperview()
            base.dialog.maskView = nil
            destroyWindow()
            completion?()
            return
        }

        guard let superview = base.superview else { return }
        UIView.animate(withDuration: duration) {
            superview.backgroundColor = UIColor.black.withDarkColor(.white).withAlphaComponent(0)
            base.tx.y = superview.tx.height
        } completion: { _ in
            destroyWindow()
            base.removeFromSuperview()
            self.base.dialog.maskView = nil
            completion?()
        }
    }

    func showInWindow(showAnimation: (() -> Void)? = nil, dismissAnimation: (() -> Void)? = nil) {
        if window == nil {
            let window = createWindow(showAnimation: showAnimation, dismissAnimation: dismissAnimation)
            base.dialog.window = window
        }
        if let window = window, !window.isKeyWindow {
            window.makeKeyAndVisible()
        }
        window?.isHidden = false
    }

    var window: UIWindow? {
        set { objc_setAssociatedObject(base, &dialogWindowKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(base, &dialogWindowKey) as? UIWindow }
    }

    func createWindow(showAnimation: (() -> Void)? = nil, dismissAnimation: (() -> Void)? = nil) -> UIWindow {
        var window: UIWindow!

        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).first as? UIWindowScene {
                window = UIWindow(windowScene: scene)
            }
        }

        if window == nil {
            window = UIWindow(frame: CGRect(x: 0, y: 0, width: ThemeSize.screenWidth, height: ThemeSize.screenHeight))
        }

//        if #available(iOS 13.0, *) {
//            window.overrideUserInterfaceStyle = ThemeType(rawValue: UserDefaultsConfig.appearance)?.style ?? .unspecified
//        }

        window.windowLevel = .normal
        window.backgroundColor = .clear
        base.dialog.maskView?.frame = window.bounds
        window.rootViewController = NCAlertController(contentView: base.dialog.maskView, showAnimation: showAnimation, dismissAnimation: dismissAnimation)

        return window
    }

    func destroyWindow() {
        if let window = base.dialog.window {
            base.dialog.window = nil
            window.isHidden = true
            if window.isKeyWindow {
                window.resignFirstResponder()
            }
            window.rootViewController = nil
        }
    }

    var maskView: UIView? {
        set { objc_setAssociatedObject(base, &dialogMaskViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { objc_getAssociatedObject(base, &dialogMaskViewKey) as? UIView }
    }

    class MaskView: UIView {
        var dismissByTouchOutsideContent = true
        let contentView: UIView
        var dismissAnimation: (() -> Void)?
        init(contentView: UIView, dismissAnimation: (() -> Void)? = nil) {
            self.contentView = contentView
            self.dismissAnimation = dismissAnimation
            super.init(frame: .zero)

            addSubview(contentView)
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGesture:))))
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        func viewTapped(tapGesture: UITapGestureRecognizer) {
            if dismissByTouchOutsideContent {
                let point = tapGesture.location(in: self)
                if contentView.frame.contains(point) {
                    return
                }

                dismissAnimation?()
            }
        }
    }
}

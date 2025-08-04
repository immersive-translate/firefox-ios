//
//  NCAlertView.swift
//  PhotonCity
//
//  Created by yuanchao on 2022/7/9.
//

import UIKit

open class NCAlertView: UIView {
    /// 内容宽度
    public var contentWidth = min(ThemeSize.screenWidth - 27 * 2, 320)

    /// 内边距，如果有topView，contentInset.top不生效
    public var contentInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)

    /// 内容的最大宽度与NCAlertView的占比，超出后内容可滚动
    public var contentMaxHeightRatio: CGFloat = 0.8

    /// 动画时长
    public var animationDuration: TimeInterval = 0.25

    /// 背景透明度
    public var backgroundOpacity = 0.6

    /// 内容区的背景视图，如果没有设置frame，内部会设置为和内容区等宽等高
    public var backgroundView: UIView?

    /// 点击内容以外的区域是否dismiss，默认false
    public var dismissByTouchOutsideContent = false

    /// 是否拦截触摸事件穿透，默认 true
    public var interceptTouchEvent = true

    /// 标题，支持类型：String、NSString、NSAttributedString
    public private(set) var title: NCAlertTextProtocol?

    /// 描述，支持类型：String、NSString、NSAttributedString
    public private(set) var message: NCAlertTextProtocol?

    /// alertAction 数组
    public lazy private(set) var alertActions: [NCAlertAction] = []

    /// textFields 数组
    public lazy private(set) var textFields: [UITextField] = []

    /// 右上角关闭按钮，位于右上角且偏移量为0，按钮默认size:42*42，图标size:18*18
    public private(set) var closeButton: UIButton?

    /// 是否正在进行动画显示/消失
    public private(set) var isAnimating = false

    /// 是否已经显示
    public private(set) var isShow = false

    /// 内容区偏移量（基于居中位置）
    public var contentOffset: UIOffset = .zero

    /// 内容区之外的视图
    public private(set) var contentOutsideViews: [ContentOutsidePosition: (view: UIView, offset: UIOffset)] = [:]

    private lazy var viewElements: [ViewElement] = []
    private lazy var alertActionButtons: [UIButton] = []

    private var elementWidth: CGFloat {
        contentWidth - contentInset.left - contentInset.right
    }

    /// 记录键盘y坐标
    private var keyboardY: CGFloat = UIScreen.main.bounds.height

    /// 如果通过`show(in viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil)`展示AlertView，alertController有值
    private var alertController: NCAlertController?

    /// 顶部视图信息
    private var topViewElement: ViewElement?

    /// 弹窗消失的闭包
    var dismissClosure: (() -> Void)?

    private var isObservingOrientation = false

    /// 初始化方法
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 描述
    public init(title: NCAlertTextProtocol?, message: NCAlertTextProtocol?) {
        super.init(frame: .zero)

        self.title = title
        self.message = message

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(notify:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stopObservingOrientation()
    }

    /// 添加AlertAction
    /// - Parameter action: NCAlertAction实例
    public func addAction(_ action: NCAlertAction) {
        alertActions.append(action)
        configAction(action)
    }

    /// 添加AlertAction
    /// - Parameters:
    ///   - title: action 标题
    ///   - style: action 样式
    ///   - handler: action 回调
    public func addAction(title: String?, style: NCAlertAction.Style, handler: ((NCAlertAction) -> Void)? = nil) {
        let action = NCAlertAction(title: title, style: style, handler: handler)
        addAction(action)
    }

    /// 添加TextField
    /// - Parameter configurationHandler: 配置textField的回调
    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = createTextField()
        configurationHandler?(textField)
        textFields.append(textField)

        let element = ViewElement(view: textField, inset: UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0), type: .textField)
        viewElements.append(element)
    }

    /// 添加自定义视图
    /// - Parameters:
    ///   - view: 自定义视图，调用方需要明确view的宽高
    ///   - inset: 自定义视图的内边距，用于设置自定义视图与上下控件的间距，只有inset.top和inset.bottom生效
    public func addCustomView(view: UIView, inset: UIEdgeInsets = .zero) {
        let element = ViewElement(view: view, inset: inset, type: .custom)
        viewElements.append(element)
    }

    /// 展示关闭按钮，按钮位于右上角且偏移量为0，关闭按钮的默认size:42*42，图标size:18*18
    public func showCloseButton() {
        closeButton = closeButton ?? createCloseButton()
    }

    /// 设置顶部视图
    /// - Parameters:
    ///   - view: 顶部视图
    ///   - inset: 内边距
    public func setTopView(_ view: UIView, inset: UIEdgeInsets = .zero) {
        topViewElement = ViewElement(view: view, inset: inset, type: .custom)
    }

    /// 设置内容区之外的视图
    /// - Parameters:
    ///   - view: 自定义内容区之外的视图
    ///   - position: 视图位置
    ///   - offset: 视图偏移，参考点是contentView的边界中点
    public func setContentOutsideView(_ view: UIView, position: ContentOutsidePosition, offset: UIOffset = .zero) {
        contentOutsideViews[position] = (view, offset)
    }

    /// 设置内容区之外的关闭按钮，会和自定义的contentOutsideView相互覆盖。关闭按钮的默认边距的绝对值为24。
    /// - Parameter position: 按钮位置
    public func setContentOutsideCloseButton(position: ContentOutsidePosition) {
        let button = createContentOutsideCloseButton()
        let offset: UIOffset

        switch position {
        case .top:
            offset = UIOffset(horizontal: 0, vertical: -24)
        case .bottom:
            offset = UIOffset(horizontal: 0, vertical: 24)
        case .left:
            offset = UIOffset(horizontal: -24, vertical: 0)
        case .right:
            offset = UIOffset(horizontal: 24, vertical: 0)
        }

        contentOutsideViews[position] = (button, offset)
    }

    /// 显示alertView
    /// - Parameters:
    ///   - view: alertView的承载view，如果不传，会取当前window
    ///   - animated: 是否动画显示，默认true
    ///   - completion: 显示完成的回调，如果animated=false回立即回调，否则动画完成后回调
    open func show(in view: UIView? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        if isAnimating || isShow {
            return
        }
        isAnimating = true

        if containerView.superview != self {
            addSubview(containerView)
        }
        containerView.dialog.maskView = self
        if let view = view {
            frame = view.bounds
        } else {
            frame = CGRect(x: 0, y: 0, width: ThemeSize.screenWidth, height: ThemeSize.screenHeight)
        }
        layout()

        containerView.dialog.showInCenter(
            in: view,
            animated: animated,
            duration: animationDuration,
            backgroundOpacity: backgroundOpacity
        ) { [weak self] in
            self?.isAnimating = false
            self?.isShow = true
            completion?()
            self?.startObservingOrientation()
        }
    }

    /// 显示alertView
    /// - Parameters:
    ///   - viewController: 显示alertView的viewController，内部会创建一个NCAlertController实例，并用viewController present NCAlertController实例
    ///   - animated: 是否动画显示，默认true
    ///   - completion: 显示完成的回调，如果animated=false回立即回调，否则动画完成后回调
    open func show(in viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if alertController?.presentingViewController != nil {
            return
        }

        let alertVC = alertController ?? NCAlertController()
        alertController = alertVC

        viewController.present(alertVC, animated: false) {
            self.show(in: alertVC.view, animated: animated, completion: completion)
        }
    }

    /// alertView消失
    /// - Parameters:
    ///   - animated: 是否动画消失，默认false
    ///   - completion: 消失完成的回调，如果animated=false回立即回调，否则动画完成后回调
    open func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if isAnimating || !isShow {
            return
        }
        isAnimating = true

        containerView.dialog.dismissInCenter(animated: animated, duration: animationDuration) { [weak self] in
            self?.isAnimating = false
            self?.isShow = false
            self?.removeFromSuperview()
            self?.dialog.destroyWindow()
            self?.containerView.dialog.maskView = nil
            self?.alertController?.dismiss(animated: false)
            self?.alertController = nil
            completion?()
            self?.dismissClosure?()
            self?.stopObservingOrientation()
        }
    }

    func configAction(_ action: NCAlertAction) {
        action.observablePropertyChanged = { [weak self, weak action] in
            guard let self = self, let action = action else { return }
            guard let index = self.alertActions.firstIndex(of: action), index < self.alertActionButtons.count else {
                return
            }

            let button = self.alertActionButtons[index]
            button.isEnabled = action.isEnabled
        }
    }

    @objc
    func actionButtonClick(button: UIButton) {
        guard let index = alertActionButtons.firstIndex(of: button), index < alertActions.count else {
            assertionFailure("internal error: alertActionButtons do not match alertActions")
            dismiss()
            return
        }

        let action = alertActions[index]

        if action.dismissWhenClickAction {
            dismiss(animated: true) {
                action.handler?(action)
            }
        } else {
            action.handler?(action)
        }
    }

    @objc
    func containerViewTapped(tapGesture: UITapGestureRecognizer) {
        containerView.endEditing(true)
    }

    @objc
    func keyboardWillChangeFrameNotification(notify: Notification) {
        guard let _ = textFields.filter({ $0.isEditing }).first,
              let beginFrame = notify.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
              let endFrame = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let interval = notify.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }

        let keyboardBeginTop = beginFrame.origin.y
        let keyboardEndTop = endFrame.origin.y

        if keyboardEndTop == keyboardBeginTop {
            return
        }

        keyboardY = keyboardEndTop
        let isShow = keyboardBeginTop > keyboardEndTop

        if isShow {
            let p = containerView.convert(CGPoint(x: 0, y: containerView.tx.height), to: containerView.window)
            if p.y > keyboardY {
                UIView.animate(withDuration: interval) {
                    self.containerView.tx.y -= (p.y - self.keyboardY)
                }
            }
        } else {
            let center = calculateContainerViewCenter()
            if containerView.center.y < center.y {
                UIView.animate(withDuration: interval) {
                    self.containerView.center.y = center.y
                }
            }
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)

        if !interceptTouchEvent {
            super.touchesBegan(touches, with: event)
        }

        if dismissByTouchOutsideContent {
            dismiss()
        }
    }

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewTapped(tapGesture:))))
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: contentWidth, height: 0))
        view.layer.cornerRadius = 16
        view.backgroundColor = .white.withDarkColor("2C2C2E")
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withDarkColor(.white)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black.withDarkColor(.white)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
}

extension NCAlertView {
    /// 内容区外的位置
    public enum ContentOutsidePosition {
        case top
        case bottom
        case left
        case right
    }
}

extension NCAlertView {
    func layout() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        contentView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(contentView)
        if containerView.superview != self {
            addSubview(containerView)
        }

        let contentMaxHeight = contentMaxHeightRatio * tx.height

        let contentWidth = contentWidth
        let contentInset = contentInset
        let elementWidth = contentWidth - contentInset.left - contentInset.right
        var calculatedHeight: CGFloat = 0
        var actionsMarginTop: CGFloat = 32

        let headerScrollContentView = UIView()
        headerScrollContentView.tx.width = contentWidth

        var hasTopView = false
        if let topViewElement = topViewElement {
            topViewElement.view.center.x = headerScrollContentView.tx.width / 2
            topViewElement.view.tx.y = topViewElement.inset.top
            headerScrollContentView.addSubview(topViewElement.view)

            calculatedHeight = topViewElement.view.frame.maxY + topViewElement.inset.bottom

            hasTopView = true
        }

        if title.isValid {
            titleLabel.setText(title!)
            titleLabel.tx.size = titleLabel.sizeThatFits(CGSize(width: elementWidth, height: CGFloat.greatestFiniteMagnitude))
            titleLabel.tx.width = elementWidth
            let top = hasTopView ? calculatedHeight : contentInset.top
            titleLabel.tx.y = top - (titleLabel.font.lineHeight - titleLabel.font.pointSize) / 2
            titleLabel.center.x = headerScrollContentView.tx.width / 2

            headerScrollContentView.addSubview(titleLabel)

            calculatedHeight = titleLabel.frame.maxY - (titleLabel.font.lineHeight - titleLabel.font.pointSize) / 2
        }

        if message.isValid {
            let fontSize: CGFloat = 14
            let marginTop: CGFloat = 16
            let lineHeight: CGFloat = 20
            messageLabel.font = UIFont.systemFont(ofSize: fontSize)
            switch message!.textType {
            case .attributedString:
                messageLabel.setText(message!)
            case let .string(text):
                let attributedText = NSMutableAttributedString(string: text)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = lineHeight
                paragraphStyle.maximumLineHeight = lineHeight
                paragraphStyle.lineBreakMode = .byTruncatingTail
                paragraphStyle.alignment = messageLabel.textAlignment
                attributedText.addAttributes([.paragraphStyle: paragraphStyle, .baselineOffset: 1], range: NSRange(location: 0, length: attributedText.string.utf16.count))
                messageLabel.setText(attributedText)
            }

            messageLabel.tx.size = messageLabel.sizeThatFits(CGSize(width: elementWidth, height: CGFloat.greatestFiniteMagnitude))
            messageLabel.tx.width = elementWidth
            messageLabel.tx.y = calculatedHeight + marginTop
            messageLabel.center.x = headerScrollContentView.tx.width / 2

            headerScrollContentView.addSubview(messageLabel)

            calculatedHeight = messageLabel.frame.maxY

            actionsMarginTop = 20
        }

        for (index, element) in viewElements.enumerated() {
            var maginTop = element.inset.top
            if element.type == .textField, index == 0, message.isValid {
                maginTop = 20
            }
            element.view.tx.y = calculatedHeight + maginTop
            element.view.center.x = headerScrollContentView.tx.width / 2

            headerScrollContentView.addSubview(element.view)

            calculatedHeight = element.view.frame.maxY + element.inset.bottom
        }

        if !viewElements.isEmpty {
            actionsMarginTop = 24
        }

        headerScrollContentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: calculatedHeight)

        // actions
        let actionScrollContentView = UIView()

        calculatedHeight = 0
//        let buttonHorizontalSpace: CGFloat = 6
        let buttonVerticalSpace: CGFloat = 16

        alertActionButtons = alertActions.map { action in
            let button = createActionButton(action: action)
            if action.style == .cancel {
                button.tx.height = 22
                button.tx.width = (button.currentTitle?.tx.width(font: button.titleLabel?.font ?? UIFont.systemFont(ofSize: 16, weight: .semibold), height: 22) ?? 32) + 2
            } else {
                button.tx.height = 46
            }
            return button
        }

        let actionCount = alertActionButtons.count
        if actionCount < 1 {
//            let leftButton = alertActionButtons[0]
//            let rightButton = alertActionButtons[1]
//
//            leftButton.tx.width = (elementWidth - buttonHorizontalSpace) / 2
//            leftButton.tx.y = calculatedHeight + actionsMarginTop
//            leftButton.tx.x = contentInset.left
//
//            rightButton.tx.width = leftButton.tx.width
//            rightButton.tx.y = leftButton.tx.y
//            rightButton.tx.x = leftButton.frame.maxX + buttonHorizontalSpace
//
//            calculatedHeight = rightButton.frame.maxY

        } else {
            for (index, button) in alertActionButtons.enumerated() {
                if button.tx.width == 0 {
                    button.tx.width = elementWidth
                    button.tx.x = contentInset.left
                } else {
                    button.tx.x = (contentWidth - button.tx.width) / 2
                }
                button.tx.y = calculatedHeight + (index == 0 ? actionsMarginTop : buttonVerticalSpace)

                calculatedHeight = button.frame.maxY
            }
        }

        alertActionButtons.forEach { actionScrollContentView.addSubview($0) }

        actionScrollContentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: calculatedHeight)

        let headerScrollView = UIScrollView()
        headerScrollView.showsVerticalScrollIndicator = false
        headerScrollView.tx.width = contentWidth
        let actionScrollView = UIScrollView()
        actionScrollView.showsVerticalScrollIndicator = false
        actionScrollView.tx.width = contentWidth

        headerScrollView.tx.height = headerScrollContentView.tx.height
        actionScrollView.tx.height = actionScrollContentView.tx.height
        // 调整两个scrollView的frame
        if headerScrollContentView.tx.height + actionScrollContentView.tx.height <= contentMaxHeight {
        } else if headerScrollContentView.tx.height > 0.5 * contentMaxHeight, actionScrollContentView.tx.height > 0.5 * contentMaxHeight {
            headerScrollView.tx.height = 0.5 * contentMaxHeight
            actionScrollView.tx.height = 0.5 * contentMaxHeight
        } else if headerScrollContentView.tx.height > 0.5 * contentMaxHeight, actionScrollContentView.tx.height < 0.5 * contentMaxHeight {
            headerScrollView.tx.height = contentMaxHeight - actionScrollView.tx.height
        } else if headerScrollContentView.tx.height < 0.5 * contentMaxHeight, actionScrollContentView.tx.height > 0.5 * contentMaxHeight {
            actionScrollView.tx.height = contentMaxHeight - headerScrollView.tx.height
        }

        headerScrollView.tx.y = 0
        headerScrollView.contentSize.height = headerScrollContentView.tx.height

        actionScrollView.tx.y = headerScrollView.tx.bottom
        actionScrollView.contentSize.height = actionScrollContentView.tx.height

        headerScrollView.addSubview(headerScrollContentView)
        actionScrollView.addSubview(actionScrollContentView)
        contentView.addSubview(headerScrollView)
        contentView.addSubview(actionScrollView)

        contentView.tx.height = actionScrollView.frame.maxY + contentInset.bottom

        if let closeButton = closeButton {
            contentView.addSubview(closeButton)
            // 如果调用方没有自定义按钮的坐标，默认右上角位置且偏移量为0
            if closeButton.tx.origin == .zero {
                closeButton.tx.y = 0
                closeButton.tx.right = contentWidth
            }
        }

        if let backgroundView = backgroundView {
            contentView.insertSubview(backgroundView, at: 0)
            contentView.clipsToBounds = true
            if backgroundView.frame == .zero {
                backgroundView.frame = contentView.bounds
            }
        }

        // 内容之外的视图
        var containerWidth = contentView.tx.width
        var containerHeight = contentView.tx.height

        if let leftViewElement = contentOutsideViews[.left] {
            containerWidth = containerWidth + leftViewElement.view.tx.width - leftViewElement.offset.horizontal
            containerView.addSubview(leftViewElement.view)
            leftViewElement.view.tx.x = 0
            leftViewElement.view.center.y = contentView.tx.height / 2
            contentView.tx.x = leftViewElement.view.tx.width - leftViewElement.offset.horizontal
        }
        if let rightViewElement = contentOutsideViews[.right] {
            containerWidth = containerWidth + rightViewElement.view.tx.width + rightViewElement.offset.horizontal
            containerView.addSubview(rightViewElement.view)
            rightViewElement.view.tx.right = containerWidth
            rightViewElement.view.center.y = contentView.tx.height / 2
        }
        if let topViewElement = contentOutsideViews[.top] {
            containerHeight = containerHeight + topViewElement.view.tx.height - topViewElement.offset.vertical
            containerView.addSubview(topViewElement.view)
            topViewElement.view.tx.y = 0
            topViewElement.view.center.x = contentView.tx.width / 2
            contentView.tx.y = topViewElement.view.tx.height - topViewElement.offset.vertical
        }
        if let bottomViewElement = contentOutsideViews[.bottom] {
            containerHeight = containerHeight + bottomViewElement.view.tx.height + bottomViewElement.offset.vertical
            containerView.addSubview(bottomViewElement.view)
            bottomViewElement.view.tx.bottom = containerHeight
            bottomViewElement.view.center.x = contentView.tx.width / 2
        }

        containerView.tx.size = CGSize(width: containerWidth, height: containerHeight)
        containerView.center = calculateContainerViewCenter()
    }

    func calculateContainerViewCenter() -> CGPoint {
        let currentCenter = containerView.center
        containerView.center = CGPoint(x: tx.width / 2, y: tx.height / 2)
        let contentPointToSelf = contentView.convert(CGPoint(x: contentView.tx.width / 2, y: contentView.tx.height / 2), to: self)
        let offsetX = contentPointToSelf.x - tx.width / 2 - contentOffset.horizontal
        let offsetY = contentPointToSelf.y - tx.height / 2 - contentOffset.vertical
        containerView.center = currentCenter

        return CGPoint(x: tx.width / 2 - offsetX, y: tx.height / 2 - offsetY)
    }
}

extension NCAlertView {
    func createActionButton(action: NCAlertAction) -> UIButton {
        let button: UIButton
        switch action.style {
        case .default:
            button = UIButton()
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        case .cancel:
            button = UIButton()
            button.backgroundColor = .clear
            button.setTitleColor(ThemeColor.c333333, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .destructive:
            button = UIButton()
            button.backgroundColor = ThemeColor.EA4C89
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .destructiveCavity:
            button = UIButton()
            button.backgroundColor = ThemeColor.c333333
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
        button.isEnabled = action.isEnabled
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle(action.title, for: .normal)
        button.addTarget(self, action: #selector(actionButtonClick(button:)), for: .touchUpInside)

        return button
    }

    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.tx.width = elementWidth
        textField.tx.height = 40
        textField.tx.x = contentInset.left
        textField.clearButtonMode = .always
        textField.backgroundColor = .gray.withDarkColor(.black)
        textField.layer.cornerRadius = 10
        textField.tintColor = UIColor(hexString: "#00DC93")
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.textColor = .black.withDarkColor(.white)

        return textField
    }

    func createCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(DialogResourceUtils.getImage(named: "close-gray-18"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonOnClick(button:)), for: .touchUpInside)
        button.tx.width = 42
        button.tx.height = 42
        return button
    }

    @objc
    func closeButtonOnClick(button: UIButton) {
        dismiss()
    }

    func createContentOutsideCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(DialogResourceUtils.getImage(named: "content-outside-close"), for: .normal)
        button.addTarget(self, action: #selector(contentOutsideCloseButtonOnClick(button:)), for: .touchUpInside)
        button.tx.width = 32
        button.tx.height = 32
        button.setEnlargeEdge(top: 6, right: 6, bottom: 6, left: 6)
        return button
    }

    @objc
    func contentOutsideCloseButtonOnClick(button: UIButton) {
        dismiss()
    }
}

extension NCAlertView {
    enum ViewElementType {
        case textField
        case custom
    }

    struct ViewElement {
        let view: UIView
        let inset: UIEdgeInsets
        let type: ViewElementType
    }
}

extension NCAlertView {
    fileprivate class GradientButton: UIButton {
        private var drawGradient = false

        override func layoutSubviews() {
            super.layoutSubviews()

            if drawGradient { return }
            drawGradient = true

            setBackgroundImage(normalBgImage, for: .normal)
        }

        private var normalBgImage: UIImage? {
            return getImage(colors: [ThemeColor.c333333].map { $0.cgColor })
        }

        private func getImage(colors: [CGColor], alpha: CGFloat = 1) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)

            let context = UIGraphicsGetCurrentContext()
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0, 1]) {
                context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: bounds.height * 0.5), end: CGPoint(x: bounds.width, y: bounds.height * 0.5), options: .drawsAfterEndLocation)
                context?.setAlpha(alpha)
                if let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
                    UIGraphicsEndImageContext()
                    return UIImage(cgImage: cgImage)
                }
            }

            UIGraphicsEndImageContext()

            return nil
        }

        override var isEnabled: Bool {
            didSet {
                super.isEnabled = isEnabled
                alpha = isEnabled ? 1 : 0.67
            }
        }
    }
}

extension NCAlertView {
    func startObservingOrientation() {
        guard !isObservingOrientation else { return }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        isObservingOrientation = true
    }

    func stopObservingOrientation() {
        guard isObservingOrientation else { return }
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
        isObservingOrientation = false
    }

    @objc
    private func orientationDidChange() {
        guard UIDevice.current.orientation.isValidInterfaceOrientation else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.dismiss {
                self?.show()
            }
        }
    }
}

public protocol NCAlertTextProtocol {
    var textType: NCAlertView.TextType { get }
}

extension NCAlertView {
    public enum TextType {
        case string(text: String)
        case attributedString(attributeText: NSAttributedString)
    }
}

extension UILabel {
    func setText(_ text: NCAlertTextProtocol) {
        switch text.textType {
        case let .string(text): self.text = text
        case let .attributedString(attributeText): attributedText = attributeText
        }
    }
}

extension String: NCAlertTextProtocol {
    public var textType: NCAlertView.TextType {
        return .string(text: self)
    }
}

extension NSAttributedString: NCAlertTextProtocol {
    public var textType: NCAlertView.TextType {
        return .attributedString(attributeText: self)
    }
}

extension NSString: NCAlertTextProtocol {
    public var textType: NCAlertView.TextType {
        return .string(text: self as String)
    }
}

extension Optional where Wrapped == NCAlertTextProtocol {
    var isValid: Bool {
        if case let .some(wrapped) = self {
            let content: String
            switch wrapped.textType {
            case let .string(text):
                content = text
            case let .attributedString(text):
                content = text.string
            }
            return !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        return false
    }
}

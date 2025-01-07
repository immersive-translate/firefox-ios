// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import ComponentLibrary

class OnboardingCardViewController: UIViewController, Themeable {
    // MARK: - Common UX Elements
    struct UX {
        static let titleLabelTopMargin: CGFloat = 68
        static let titleLabelLeftMargin: CGFloat = 26
        static let buttonBottomMargin: CGFloat = 16
        static let primaryButtonHeight: CGFloat = 50
        static let secondaryButtonHeight: CGFloat = 40
        static let itemImageViewSize: CGSize = CGSizeMake(67.5, 67.5)

    }
    
    struct SharedUX {
        static let topStackViewSpacing: CGFloat = 24
        static let titleFont: UIFont = {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return FXFontStyles.Bold.title1.scaledFont()
            } else {
                return FXFontStyles.Bold.title2.scaledFont()
            }
        }()

        // small device
        static let smallStackViewSpacing: CGFloat = 8
        static let smallScrollViewVerticalPadding: CGFloat = 20
    }

    let windowUUID: WindowUUID
    var currentWindowUUID: UUID? { windowUUID }

    // Adjusting layout for devices with height lower than 667
    // including now iPhone SE 2nd generation and iPad
    var shouldUseSmallDeviceLayout: Bool {
        return view.frame.height <= 667 || UIDevice.current.userInterfaceIdiom == .pad
    }

    // Adjusting layout for tiny devices (iPhone SE 1st generation)
    var shouldUseTinyDeviceLayout: Bool {
        return UIDevice().isTinyFormFactor
    }

    // MARK: - Common UI Elements
    lazy var scrollView: UIScrollView = .build { view in
        view.backgroundColor = .clear
    }

    lazy var containerView: UIView = .build { view in
        view.backgroundColor = .clear
    }

    lazy var contentContainerView: UIView = .build { stack in
        stack.backgroundColor = .clear
    }

    lazy var topStackView: UIStackView = .build { stack in
        stack.backgroundColor = .clear
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = SharedUX.topStackViewSpacing
        stack.axis = .vertical
    }

    lazy var contentStackView: UIStackView = .build { stack in
        stack.backgroundColor = .clear
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.axis = .vertical
    }
    lazy var imageView: UIImageView = .build { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "\(self.viewModel.a11yIdRoot)ImageView"
    }

    lazy var titleLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = self.shouldUseSmallDeviceLayout ? FXFontStyles.Bold.title3.scaledFont() : SharedUX.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "\(self.viewModel.a11yIdRoot)TitleLabel"
        label.accessibilityTraits.insert(.header)
    }

    lazy var descriptionLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = FXFontStyles.Regular.body.scaledFont()
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "\(self.viewModel.a11yIdRoot)DescriptionLabel"
    }
    
    lazy var primaryButton: PrimaryRoundedButton = .build { button in
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true;
        button.addTarget(self, action: #selector(self.primaryAction), for: .touchUpInside)
        button.backgroundColor = UIColor(colorString: "222222");
    }

    lazy var secondaryButton: SecondaryRoundedButton = .build { button in
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.secondaryAction), for: .touchUpInside)
        button.backgroundColor = UIColor(colorString: "999999")
        button.backgroundColor = .clear
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: ImageIdentifiers.homeHeaderLogoBall)
        return imageView
    }()

    // MARK: - Themeable
    var themeManager: Common.ThemeManager
    var themeObserver: NSObjectProtocol?
    var notificationCenter: Common.NotificationProtocol

    var viewModel: OnboardingCardInfoModelProtocol

    // MARK: - Initializers
    init(
        viewModel: OnboardingCardInfoModelProtocol,
        windowUUID: WindowUUID,
        themeManager: ThemeManager = AppContainer.shared.resolve(),
        notificationCenter: NotificationProtocol = NotificationCenter.default
    ) {
        self.viewModel = viewModel
        self.windowUUID = windowUUID
        self.themeManager = themeManager
        self.notificationCenter = notificationCenter

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (viewModel.name == "welcome") {
            setupFirstIntroView()
        } else if (viewModel.name == "sign-to-sync") {
            setupSecondaryIntroView()
        } else if (viewModel.name == "notification-permissions") {
            setupThirdIntroView()
        }
    }

    func currentTheme() -> Theme {
        return themeManager.getCurrentTheme(for: windowUUID)
    }

    func updateLayout() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.body
        imageView.image = viewModel.image

        setupPrimaryButton()
        setupSecondaryButton()
    }
    
    // MARK: - View setup
    func setupFirstIntroView() {
        titleLabel.text = "将沉浸式翻译设置为默认浏览器"
        view.addSubview(titleLabel)
        
        descriptionLabel.text = "任何外文网页默认用沉浸式翻译浏览器打开并自动翻译； \n搜索结果自动翻译为母语。"
        view.addSubview(descriptionLabel)
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: "设为默认浏览器", attributes: primaryAttribute)
        primaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(primaryButton);
        
        let secondaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 12),
                                  NSAttributedString.Key.foregroundColor:  UIColor(colorString: "999999")]
        let secondaryAttributeTitle = NSAttributedString(string: "稍后设置", attributes: secondaryAttribute)
        secondaryButton.setAttributedTitle(secondaryAttributeTitle, for: .normal)
        view.addSubview(secondaryButton);
        
        let selectLanguageView = SelectLanguageView();
        selectLanguageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectLanguageView);
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UX.titleLabelTopMargin),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            selectLanguageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            selectLanguageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            selectLanguageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectLanguageView.bottomAnchor.constraint(equalTo: primaryButton.topAnchor, constant: -60),
            secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UX.buttonBottomMargin),
            secondaryButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryButton.heightAnchor.constraint(equalToConstant: UX.secondaryButtonHeight),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: -UX.buttonBottomMargin),
            primaryButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
    }
    
    
    func setupSecondaryIntroView() {
        titleLabel.text = "无障碍阅读外语内容："
        view.addSubview(titleLabel)
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: "我知道了🫡", attributes: primaryAttribute)
        primaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(primaryButton);
        
        let contentView = UIView();
        contentView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(contentView);
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        label.font = DefaultDynamicFontHelper.preferredBoldFont(withTextStyle: .largeTitle,
                                                                size: 20.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .center;
        let labelAttribute = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let labelAttributeTitle = NSAttributedString(string: "全部一键翻译，\n阅读再无障碍！🎉", attributes: labelAttribute)
        label.attributedText = labelAttributeTitle
        label.textColor = UIColor(colorString: "222222")
        contentView.addSubview(label);

        let webItemView = createLogoAndDescView(imageName: "web-intro", desc: "网页")
        contentView.addSubview(webItemView);
        
        let videoItemView = createLogoAndDescView(imageName: "video-intro", desc: "视频")
        contentView.addSubview(videoItemView);

        let documentItemView = createLogoAndDescView(imageName: "document-intro", desc: "文档")
        contentView.addSubview(documentItemView);
        
        let itemMargin = (view.frame.size.width - 3 * UX.itemImageViewSize.width) / 4

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            videoItemView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -60),
            videoItemView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            videoItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            webItemView.topAnchor.constraint(equalTo: videoItemView.topAnchor),
            webItemView.rightAnchor.constraint(equalTo: videoItemView.leftAnchor, constant:  -itemMargin),
            documentItemView.topAnchor.constraint(equalTo: videoItemView.topAnchor),
            documentItemView.leftAnchor.constraint(equalTo: videoItemView.rightAnchor, constant:  itemMargin),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UX.titleLabelTopMargin),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            primaryButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
    }
    
    
    func setupThirdIntroView() {
        view.addSubview(logoImageView)
        
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 0
        label.font = DefaultDynamicFontHelper.preferredBoldFont(withTextStyle: .largeTitle,
                                                                size: 32.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        paragraphStyle.alignment = .center;
        let labelAttribute = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let labelAttributeTitle = NSAttributedString(string: "消除语言障碍\n看见更大的世界", attributes: labelAttribute)
        label.attributedText = labelAttributeTitle
        label.textColor = UIColor(colorString: "222222")
        view.addSubview(label);
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: "开启无语言障碍的世界！", attributes: primaryAttribute)
        primaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(primaryButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -26),
            logoImageView.widthAnchor.constraint(equalToConstant: 70.0),
            logoImageView.heightAnchor.constraint(equalToConstant: 70.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UX.buttonBottomMargin),
            primaryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            primaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
    }
    
    func createLogoAndDescView(imageName: String, desc: String) -> UIView {
        let itemView = UIView();
        itemView.translatesAutoresizingMaskIntoConstraints = false;
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill;
        imageView.image = UIImage(imageLiteralResourceName: imageName)
        itemView.addSubview(imageView);
        
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        label.font = DefaultDynamicFontHelper.preferredBoldFont(withTextStyle: .largeTitle,
                                                                size: 16.0)
        label.text = desc
        label.textColor = UIColor(colorString: "222222")
        itemView.addSubview(label)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: UX.itemImageViewSize.width),
            imageView.heightAnchor.constraint(equalToConstant: UX.itemImageViewSize.height),
            imageView.leftAnchor.constraint(equalTo: itemView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: itemView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0),
            label.bottomAnchor.constraint(equalTo: itemView.bottomAnchor),
        ])
        return itemView
    }

    @objc
    func primaryAction() { }

    @objc
    func secondaryAction() { }

    func setupPrimaryButton() {
        let buttonViewModel = PrimaryRoundedButtonViewModel(
            title: viewModel.buttons.primary.title,
            a11yIdentifier: "\(self.viewModel.a11yIdRoot)PrimaryButton"
        )

        primaryButton.configure(viewModel: buttonViewModel)
        primaryButton.applyTheme(theme: themeManager.getCurrentTheme(for: windowUUID))
    }

    func setupSecondaryButton() {
        let buttonViewModel = SecondaryRoundedButtonViewModel(
            title: viewModel.buttons.secondary?.title,
            a11yIdentifier: "\(self.viewModel.a11yIdRoot)SecondaryButton"
        )

        secondaryButton.configure(viewModel: buttonViewModel)
        secondaryButton.applyTheme(theme: currentTheme())
    }

    func applyTheme() { }
}

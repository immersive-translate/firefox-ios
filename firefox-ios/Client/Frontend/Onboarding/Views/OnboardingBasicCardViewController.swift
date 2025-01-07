// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit
import Common
import ComponentLibrary
import Shared

class OnboardingBasicCardViewController: OnboardingCardViewController {
    struct UX {
        static let titleLabelTopMargin: CGFloat = 68
        static let titleLabelLeftMargin: CGFloat = 26
        static let buttonBottomMargin: CGFloat = 16
        static let primaryButtonHeight: CGFloat = 50
        static let secondaryButtonHeight: CGFloat = 40
        static let itemImageViewSize: CGSize = CGSizeMake(67.5, 67.5)

    }

    // MARK: - Properties
    weak var delegate: OnboardingCardDelegate?

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: ImageIdentifiers.homeHeaderLogoBall)
        return imageView
    }()

    // MARK: - Initializers
    init(
        viewModel: OnboardingCardInfoModelProtocol,
        delegate: OnboardingCardDelegate?,
        windowUUID: WindowUUID
    ) {
        self.delegate = delegate

        super.init(viewModel: viewModel, windowUUID: windowUUID)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        listenForThemeChange(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.pageChanged(from: viewModel.name)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.sendCardViewTelemetry(from: viewModel.name)
    }

    // MARK: - View setup
    func setupFirstIntroView() {
        titleLabel.text = .ImtLocalizableIntroDefaultBrowser
        view.addSubview(titleLabel)
        
        descriptionLabel.text = .ImtLocalizableIntroAutoTranslated
        view.addSubview(descriptionLabel)
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroSetDefaultBrowser, attributes: primaryAttribute)
        primaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(primaryButton);
        
        let secondaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 12),
                                  NSAttributedString.Key.foregroundColor:  UIColor(colorString: "999999")]
        let secondaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroSetLater, attributes: secondaryAttribute)
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
        let theme = currentTheme()
        titleLabel.text = .ImtLocalizableIntroAccessibleReading
        view.addSubview(titleLabel)
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableReminderISee + "🫡", attributes: primaryAttribute)
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
        let labelAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroAllTranslated + "🎉", attributes: labelAttribute)
        label.attributedText = labelAttributeTitle
        label.textColor = theme.colors.textPrimary
        contentView.addSubview(label);

        let webItemView = createLogoAndDescView(imageName: "web-intro", desc: .ImtLocalizableIntroWebPage)
        contentView.addSubview(webItemView);
        
        let videoItemView = createLogoAndDescView(imageName: "video-intro", desc: .ImtLocalizableIntroVideo)
        contentView.addSubview(videoItemView);

        let documentItemView = createLogoAndDescView(imageName: "document-intro", desc: .ImtLocalizableIntroDocument)
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
        let theme = currentTheme()
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
        let labelAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroBiggerWorld, attributes: labelAttribute)
        label.attributedText = labelAttributeTitle
        label.textColor = theme.colors.textPrimary
        view.addSubview(label);
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroBreakBarriers, attributes: primaryAttribute)
        primaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(primaryButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3),
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
        let theme = currentTheme()
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
        label.textColor = theme.colors.textPrimary
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

    // MARK: - Button Actions
    @objc
    override func primaryAction() {
        delegate?.handleBottomButtonActions(
            for: viewModel.buttons.primary.action,
            from: viewModel.name,
            isPrimaryButton: true)
    }

    @objc
    override func secondaryAction() {
        guard let buttonAction = viewModel.buttons.secondary?.action else { return }

        delegate?.handleBottomButtonActions(
            for: buttonAction,
            from: viewModel.name,
            isPrimaryButton: false)
    }

    @objc
    func linkButtonAction() {
        delegate?.handleBottomButtonActions(
            for: .readPrivacyPolicy,
            from: viewModel.name,
            isPrimaryButton: false)
    }

    // MARK: - Themeable
    override func applyTheme() {
        let theme = currentTheme()
        titleLabel.textColor = theme.colors.textPrimary
        descriptionLabel.textColor = theme.colors.textPrimary

        primaryButton.applyTheme(theme: theme)
        setupSecondaryButton()
        if (viewModel.name == "welcome") {
            setupFirstIntroView()
        } else if (viewModel.name == "sign-to-sync") {
            setupSecondaryIntroView()
        } else if (viewModel.name == "notification-permissions") {
            setupThirdIntroView()
        }
    }
}

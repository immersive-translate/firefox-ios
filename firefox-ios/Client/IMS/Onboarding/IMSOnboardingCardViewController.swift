// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import UIKit
import Common
import ComponentLibrary
import Shared

class IMSOnboardingCardViewController: OnboardingCardViewController {
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

    private lazy var imstitleLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = DefaultDynamicFontHelper.preferredBoldFont(withTextStyle: .largeTitle,
                                                                size: 20.0)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "\(self.viewModel.a11yIdRoot)TitleLabel"
        label.accessibilityTraits.insert(.header)
    }

    private lazy var imsdescriptionLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = DefaultDynamicFontHelper.preferredFont(withTextStyle: .body,
                                                            size: 14.0)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "\(self.viewModel.a11yIdRoot)DescriptionLabel"
    }
    
    private lazy var imsprimaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true;
        button.addTarget(self, action: #selector(self.primaryAction), for: .touchUpInside)
        button.backgroundColor = UIColor(colorString: "222222");
        return button
    }()
    
    private lazy var imssecondaryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.secondaryAction), for: .touchUpInside)
        button.backgroundColor = UIColor(colorString: "999999")
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var imslogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill;
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(imageLiteralResourceName: ImageIdentifiers.homeHeaderLogoBall)
        return imageView
    }()
    
    let items = [
        IMSGridItem(icon: "web-intro", title: .ImtLocalizableIntroWebPage),
        IMSGridItem(icon: "video-intro", title: .ImtLocalizableIntroVideo),
        IMSGridItem(icon: "document-intro", title: .ImtLocalizableIntroDocument),
        IMSGridItem(icon: "cartoon-intro", title: .ImtLocalizableComicTranslation),
        IMSGridItem(icon: "xiaohongshu-intro", title: .ImtLocalizableXiaohongshu),
        IMSGridItem(icon: "BiLinSearch-intro", title: .ImtLocalizableBiLinSearch),
    ]


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
        if (viewModel.name == "select-language") {
            setupFirstIntroView()
        } else if (viewModel.name == "translate-intro") {
            setupSecondaryIntroView()
        } else if (viewModel.name == "welcome-intro") {
            setupThirdIntroView()
        }
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
        imstitleLabel.text = .ImtLocalizableIntroDefaultBrowser
        view.addSubview(imstitleLabel)
        
        imsdescriptionLabel.text = .ImtLocalizableIntroAutoTranslated
        view.addSubview(imsdescriptionLabel)
        
        let primaryAttribute = [
            NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.underlineStyle: 0
                
        ] as [NSAttributedString.Key : Any]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroSetDefaultBrowser, attributes: primaryAttribute)
        imsprimaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(imsprimaryButton);
        
        let secondaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 12),
                                  NSAttributedString.Key.foregroundColor:  UIColor(colorString: "999999")]
        let secondaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroSetLater, attributes: secondaryAttribute)
        imssecondaryButton.setAttributedTitle(secondaryAttributeTitle, for: .normal)
        view.addSubview(imssecondaryButton);
        
        let selectLanguageView = SelectLanguageView();
        selectLanguageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectLanguageView);
        
        NSLayoutConstraint.activate([
            imstitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UX.titleLabelTopMargin),
            imstitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            imstitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsdescriptionLabel.topAnchor.constraint(equalTo: imstitleLabel.bottomAnchor, constant: 16),
            imsdescriptionLabel.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imsdescriptionLabel.centerXAnchor.constraint(equalTo: imstitleLabel.centerXAnchor),
            selectLanguageView.topAnchor.constraint(equalTo: imsdescriptionLabel.bottomAnchor, constant: 40),
            selectLanguageView.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            selectLanguageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectLanguageView.bottomAnchor.constraint(equalTo: imsprimaryButton.topAnchor, constant: -60),
            imssecondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UX.buttonBottomMargin),
            imssecondaryButton.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imssecondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imssecondaryButton.heightAnchor.constraint(equalToConstant: UX.secondaryButtonHeight),
            imsprimaryButton.bottomAnchor.constraint(equalTo: imssecondaryButton.topAnchor, constant: -UX.buttonBottomMargin),
            imsprimaryButton.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imsprimaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsprimaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
    }
    
    
    func setupSecondaryIntroView() {
        imstitleLabel.text = .ImtLocalizableIntroAccessibleReading
        view.addSubview(imstitleLabel)
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableReminderISee + "🫡", attributes: primaryAttribute)
        imsprimaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(imsprimaryButton);
        
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
        label.textColor = UIColor(colorString: "222222")
        contentView.addSubview(label);

        let gridView = IMSGridView(columns: 3, config: .init(horizontalSpacing: 0, verticalSpacing: 28, imageSize: .init(width: 67, height: 67), titleFont: .systemFont(ofSize: 16)))
        
        gridView.configure(with: items)
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gridView)
        
        

        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gridView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -60),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imstitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UX.titleLabelTopMargin),
            imstitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            imstitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 26),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            
            imsprimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            imsprimaryButton.leftAnchor.constraint(equalTo: imstitleLabel.leftAnchor),
            imsprimaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsprimaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
        ])
    }
    
    
    func setupThirdIntroView() {
        view.addSubview(imslogoImageView)
        
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
        label.textColor = UIColor(colorString: "222222")
        view.addSubview(label);
        
        let primaryAttribute = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.white]
        let primaryAttributeTitle = NSAttributedString(string: .ImtLocalizableIntroBreakBarriers, attributes: primaryAttribute)
        imsprimaryButton.setAttributedTitle(primaryAttributeTitle, for: .normal)
        view.addSubview(imsprimaryButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3),
            imslogoImageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -26),
            imslogoImageView.widthAnchor.constraint(equalToConstant: 70.0),
            imslogoImageView.heightAnchor.constraint(equalToConstant: 70.0),
            imslogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsprimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UX.buttonBottomMargin),
            imsprimaryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UX.titleLabelLeftMargin),
            imsprimaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imsprimaryButton.heightAnchor.constraint(equalToConstant: UX.primaryButtonHeight),
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

    }
}

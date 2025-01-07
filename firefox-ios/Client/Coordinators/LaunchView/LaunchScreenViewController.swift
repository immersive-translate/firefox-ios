// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import UIKit
import Shared

class LaunchTextView : UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class LaunchScreenViewController: UIViewController, LaunchFinishedLoadingDelegate, UITextViewDelegate {
    
    struct UX {
        static let cornerRadius: CGFloat = 28
        static let horizontalMargin: CGFloat = 32
        static let titleTopMargin: CGFloat = 10
        static let descTopMargin: CGFloat = 10
        static let buttonHeight: CGFloat = 44
        static let buttonTopMargin: CGFloat = 16
        static let buttonBottomMargin: CGFloat = 32
        static let showProtocolPopupKey: String = "have-show-protocol-popup"
        static let userProtocolScheme: String = "userProtocol"
        static let privacyPolicyScheme: String = "privacyPolicy"
    }
    
    private lazy var launchScreen = LaunchScreenView.fromNib()!
    private weak var coordinator: LaunchFinishedLoadingDelegate?
    private var viewModel: LaunchScreenViewModel
    private var mainQueue: DispatchQueueInterface
    private var isFirstStep = true
    private var launchFinish = false
    private var windowUUID: WindowUUID

    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cornerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = UX.cornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 24);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "温馨提示";
        return titleLabel
    }()
    
    private lazy var textView: LaunchTextView = {
        let view = LaunchTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.isScrollEnabled = false
        view.delegate = self
        view.backgroundColor = UIColor.white
        view.linkTextAttributes = [NSAttributedString.Key.font: UIFont .boldSystemFont(ofSize: 16),
                                   NSAttributedString.Key.foregroundColor: UIColor.black]
        return view
    }()
    
    private lazy var leftButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true;
        view.addTarget(self, action: #selector(leftButtonTap), for: .touchUpInside)
        view.backgroundColor = UIColor(colorString: "f5f5fa");
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setTitle("同意", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6.0
        view.layer.masksToBounds = true;
        view.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
        view.backgroundColor = UIColor(colorString: "f5f5fa");
        return view
    }()
        
    init(windowUUID: WindowUUID,
         coordinator: LaunchFinishedLoadingDelegate,
         viewModel: LaunchScreenViewModel? = nil,
         mainQueue: DispatchQueueInterface = DispatchQueue.main) {
        self.windowUUID = windowUUID
        self.coordinator = coordinator
        self.viewModel = viewModel ?? LaunchScreenViewModel(windowUUID: windowUUID)
        self.mainQueue = mainQueue
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        if UserDefaults.standard.string(forKey: UX.showProtocolPopupKey) != nil {
            Task {
                await startLoading()
            }
        } else {
//            viewModel.needShowProtocolPopup = true;
            showProtocol();
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = self.launchFinish;
    }

    // MARK: - Loading

    func startLoading() async {
        self.launchFinish = true;
        await viewModel.startLoading()
    }

    // MARK: - Setup

    private func setupLayout() {
        launchScreen.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(launchScreen)
        
        NSLayoutConstraint.activate([
            launchScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchScreen.topAnchor.constraint(equalTo: view.topAnchor),
            launchScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func showProtocol() {
        view.addSubview(dimView)
        dimView.addSubview(cornerView);
        dimView.addSubview(contentView);
        contentView.addSubview(titleLabel);
        contentView.addSubview(textView);
        contentView.addSubview(leftButton);
        contentView.addSubview(rightButton);
        updateUI();
        
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cornerView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            cornerView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            cornerView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: UX.cornerRadius),
            cornerView.heightAnchor.constraint(equalToConstant: UX.cornerRadius * 2),
            
            contentView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UX.horizontalMargin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UX.titleTopMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UX.horizontalMargin),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UX.descTopMargin),
            textView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            leftButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: UX.buttonTopMargin),
            leftButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: UX.buttonHeight),
            
            rightButton.topAnchor.constraint(equalTo: leftButton.topAnchor),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: UX.horizontalMargin),
            rightButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            rightButton.heightAnchor.constraint(equalTo: leftButton.heightAnchor),
            rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor),
            
            leftButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UX.buttonBottomMargin)
        ])
    }
    
    private func updateUI() {
        let normalAttributes = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                NSAttributedString.Key.foregroundColor: UIColor.black]
        let userlinkAttributes = [NSAttributedString.Key.font: UIFont .boldSystemFont(ofSize: 16),
                                  NSAttributedString.Key.strokeColor: UIColor.black,
                                  NSAttributedString.Key.link: UX.userProtocolScheme + "://"] as [NSAttributedString.Key : Any];
        let protocolLinkAttributes = [NSAttributedString.Key.font: UIFont .boldSystemFont(ofSize: 16),
                                      NSAttributedString.Key.strokeColor: UIColor.black,
                                      NSAttributedString.Key.link: UX.privacyPolicyScheme + "://"] as [NSAttributedString.Key : Any];
        let leftButtonAttributes = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                    NSAttributedString.Key.foregroundColor: UIColor.black]
        let rightButtonAttributes = [NSAttributedString.Key.font: UIFont .systemFont(ofSize: 16),
                                    NSAttributedString.Key.foregroundColor: UIColor.blue]
        if isFirstStep {
            let attStr = NSMutableAttributedString(string: "欢迎使用沉浸式翻译。在使用沉浸式翻译前，请认真阅读",
                                                   attributes: normalAttributes)
            attStr.append(NSAttributedString(string: "《用户协议》", attributes: userlinkAttributes))
            attStr.append(NSAttributedString(string: "和", attributes: normalAttributes))
            attStr.append(NSAttributedString(string: "《沉浸式翻译浏览器隐私政策》", attributes: protocolLinkAttributes))
            attStr.append(NSAttributedString(string: "。根据《常见类型移动互联网应用程序必要个人信息范围规定》，沉浸式翻译的主要功能为网址浏览、搜索、文件处理、文件管理等，扩展功能包括沉浸式翻译账号等。同意基本功能隐私政策仅代表同意使用网址浏览、搜索、文件处理、文件管理等主要功能时收集、处理相关必要信息，沉浸式翻译账号等拓展功能收集个人信息将在您使用具体功能时单独征求您的同意。", attributes: normalAttributes))
            textView.attributedText = attStr;
            leftButton.setAttributedTitle(NSAttributedString(string: "不同意", attributes: leftButtonAttributes), for: .normal);
            rightButton.setAttributedTitle(NSAttributedString(string: "同意并继续", attributes: rightButtonAttributes), for: .normal);
            return
        }
        let attStr = NSMutableAttributedString(string: "本产品需要同意相关协议后才能使用哦",
                                               attributes: normalAttributes)
        textView.attributedText = attStr;
        leftButton.setAttributedTitle(NSAttributedString(string: "退出应用", attributes: leftButtonAttributes), for: .normal);
        rightButton.setAttributedTitle(NSAttributedString(string: "我知道了", attributes: rightButtonAttributes), for: .normal);
    }
    
    // MARK: - Action
    
    @objc
    func leftButtonTap() {
        if isFirstStep {
            isFirstStep = false
            updateUI()
            return
        }
        exit(0)
    }
    
    
    @objc
    func rightButtonTap() {
        if isFirstStep {
            UserDefaults.standard.setValue("1", forKey: UX.showProtocolPopupKey)
            Task {
               await startLoading()
            }
            return
        }
        isFirstStep = true;
        updateUI();
    }


    // MARK: - LaunchFinishedLoadingDelegate

    func launchWith(launchType: LaunchType) {
        mainQueue.async {
            self.coordinator?.launchWith(launchType: launchType)
        }
    }

    func launchBrowser() {
        mainQueue.async {
            self.coordinator?.launchBrowser()
        }
    }
    
    // MARK: - UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme  == UX.userProtocolScheme {
            let viewController = SettingsContentViewController(windowUUID: windowUUID)
            viewController.settingsTitle = NSAttributedString(string: "用户协议")
            viewController.url = Foundation.URL(string: "https://immersivetranslate.com/docs/TERMS/")
            self.navigationController?.pushViewController(viewController, animated: true);
            return false
        } else if URL.scheme == UX.privacyPolicyScheme {
            let viewController = SettingsContentViewController(windowUUID: windowUUID)
            viewController.settingsTitle = NSAttributedString(string: "隐私政策")
            viewController.url = Foundation.URL(string: "https://immersivetranslate.com/docs/PRIVACY/")
            self.navigationController?.pushViewController(viewController, animated: true);
            return false
        }
        return true
    }

}

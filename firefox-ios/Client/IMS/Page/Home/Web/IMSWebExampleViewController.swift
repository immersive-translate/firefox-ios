// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct SelectedWebModel {
    var name: String
    var icon: UIImage?
    var url: String
}

struct IMSSelectedWebModel {
    var image: UIImage?
    var title: String
    var url: String
    
    var name: String
    var icon: UIImage?
    var time: String
}

class IMSWebExampleViewController: BaseViewController {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "example_close"), for: .normal)
        button.backgroundColor = ThemeColor.TY.c00000008
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(closeButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "网页翻译"
        return label
    }()
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var tutorialContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = ThemeColor.TC.F3F5F6
        return view
    }()
    
    private lazy var tutorialBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.ZX.FFFFFF.withAlphaComponent(0.7)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var fingerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example_finger")
        return imageView
    }()
    
    private lazy var languageIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "toolbar_tranlate_normal")
        return imageView
    }()
    
    private lazy var settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "toolbar_tranlate_setting")
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "任何网页中点击地址栏中的\"翻译图标\"\n即可一键翻译"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var popularSitesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "🔥 全球精选网站"
        return label
    }()
    
    private lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("查看更多", for: .normal)
        button.setTitleColor(ThemeColor.Other.c4181F0, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(viewMoreButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var popularSitesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var morePopularSitesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.spacing = 20
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var examplesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "沉浸式翻译精选"
        return label
    }()
    
    private lazy var examplesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let popularSites: [SelectedWebModel] = [
        SelectedWebModel(name: "YouTube", icon: UIImage(named: "example_web_youtube"), url: "https://www.youtube.com"),
        SelectedWebModel(name: "Google", icon: UIImage(named: "example_web_google"), url: "https://www.google.com"),
        SelectedWebModel(name: "ChatGPT", icon: UIImage(named: "example_web_chatgpt"), url: "https://chat.openai.com"),
        SelectedWebModel(name: "Bilin", icon: UIImage(named: "example_web_bilin"), url: "https://www.bilibili.com"),
    ]
    
    private let morePopularSites: [SelectedWebModel] = [
        SelectedWebModel(name: "Reddit", icon: UIImage(named: "example_web_reddit"), url: "https://www.reddit.com"),
        SelectedWebModel(name: "X", icon: UIImage(named: "example_web_x"), url: "https://twitter.com"),
        SelectedWebModel(name: "维基百科", icon: UIImage(named: "example_web_wikipedia"), url: "https://www.wikipedia.org"),
        SelectedWebModel(name: "亚马逊", icon: UIImage(named: "example_web_amazon"), url: "https://www.amazon.com"),
    ]
    
    private let imsPopularSites: [IMSSelectedWebModel] = [
        IMSSelectedWebModel(image: UIImage(named: "ic_site_youtube"), title: "YouTube", url: "https://www.youtube.com", name: "YouTube", icon: UIImage(named: "ic_site_youtube"), time: "YouTube"),
        IMSSelectedWebModel(image: UIImage(named: "ic_site_youtube"), title: "YouTube", url: "https://www.youtube.com", name: "YouTube", icon: UIImage(named: "ic_site_youtube"), time: "YouTube"),
        IMSSelectedWebModel(image: UIImage(named: "ic_site_youtube"), title: "YouTube", url: "https://www.youtube.com", name: "YouTube", icon: UIImage(named: "ic_site_youtube"), time: "YouTube"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        // 添加主要视图元素
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(mainScrollView)
        mainScrollView.backgroundColor = view.backgroundColor
        mainScrollView.addSubview(contentContainerView)
        contentContainerView.addSubview(tutorialContainerView)
        tutorialContainerView.addSubview(tutorialBannerView)
        tutorialBannerView.addSubview(languageIconImageView)
        tutorialBannerView.addSubview(settingsImageView)
        tutorialContainerView.addSubview(fingerImageView)
        tutorialContainerView.addSubview(descriptionLabel)
        
        let bgView = UIView()
        bgView.backgroundColor = view.backgroundColor
        bgView.layer.cornerRadius = 20
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.04
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 6
        contentContainerView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(tutorialContainerView.snp.bottom).offset(-12)
            make.left.right.bottom.equalToSuperview()
        }
        
        bgView.addSubview(popularSitesLabel)
        bgView.addSubview(viewMoreButton)
        bgView.addSubview(popularSitesStackView)
        bgView.addSubview(morePopularSitesStackView)
        bgView.addSubview(examplesLabel)
        bgView.addSubview(examplesStackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.equalToSuperview().offset(24)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(32)
        }
        
        mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(mainScrollView)
            make.width.equalTo(mainScrollView)
        }
        
        tutorialContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(170)
        }
        
        tutorialBannerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(44)
        }
        
        settingsImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        languageIconImageView.snp.makeConstraints { make in
            make.right.equalTo(settingsImageView.snp.left).offset(-16)
            make.centerY.width.height.equalTo(settingsImageView)
        }
        
        fingerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.top.equalTo(languageIconImageView.snp.bottom).offset(-10)
            make.right.equalTo(languageIconImageView.snp.left).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tutorialBannerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(31)
            make.right.equalToSuperview().offset(-32)
        }
        
        popularSitesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(24)
        }
        
        viewMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(popularSitesLabel)
            make.right.equalToSuperview().offset(-24)
        }
        
        popularSitesStackView.snp.makeConstraints { make in
            make.top.equalTo(popularSitesLabel.snp.bottom).offset(16)
            make.height.equalTo(75)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        morePopularSitesStackView.snp.makeConstraints { make in
            make.top.equalTo(popularSitesStackView.snp.bottom).offset(24)
            make.left.right.equalTo(popularSitesStackView)
            make.height.equalTo(0)
        }
        
        examplesLabel.snp.makeConstraints { make in
            make.top.equalTo(morePopularSitesStackView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
        }
        
        examplesStackView.snp.makeConstraints { make in
            make.top.equalTo(examplesLabel.snp.bottom).offset(16)
            make.left.right.equalTo(popularSitesStackView)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupData() {
        for (index, item) in imsPopularSites.enumerated() {
            let exampleView = createExampleView(image: item.icon, index: index)
            examplesStackView.addArrangedSubview(exampleView)
        }
        
        for site in popularSites {
            let siteView = createSiteView(site: site)
            popularSitesStackView.addArrangedSubview(siteView)
        }
        
        for site in morePopularSites {
            let siteView = createSiteView(site: site)
            morePopularSitesStackView.addArrangedSubview(siteView)
        }
    }
}

extension IMSWebExampleViewController {
    private func createSiteView(site: SelectedWebModel) -> UIView {
        let containerView = UIView()
        containerView.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        let iconImageView = UIImageView()
        iconImageView.image = site.icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 12
        iconImageView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = site.name
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = ThemeColor.ZX.c666666
        nameLabel.textAlignment = .center
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(siteTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        if let index = popularSites.firstIndex(where: { $0.name == site.name }) {
            containerView.tag = index
        }
        
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }

    private func createExampleView(image: UIImage?, index: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(170)
        }
        
        let exampleImageView = UIImageView()
        exampleImageView.image = image
        exampleImageView.contentMode = .scaleAspectFill
        exampleImageView.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.text = "sam altman: 我早就应该知道的事!"
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = ThemeColor.ZX.c222222
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "avatar_example")
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 10
        
        let sourceLabel = UILabel()
        sourceLabel.text = "沉浸式翻译小助手 2天前"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = ThemeColor.ZX.c999999
        
        containerView.addSubview(exampleImageView)
        containerView.addSubview(textLabel)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(sourceLabel)
        
        exampleImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(exampleImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(20)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(4)
        }
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exampleTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = 1000 + index
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }
}

extension IMSWebExampleViewController {
    @objc
    private func closeButtonOnClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func searchTextButtonOnClick() {
        // Handle search text button click
    }
    
    @objc
    private func settingsButtonOnClick() {
        // Handle settings button click
    }
    
    @objc
    private func viewMoreButtonOnClick() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.morePopularSitesStackView.snp.updateConstraints { make in
                make.height.equalTo(self.morePopularSitesStackView.isHidden ? 75 : 0)
            }
            self.view.layoutIfNeeded()
        }, completion: { [weak self]  _ in
            guard let self = self else { return }
            morePopularSitesStackView.isHidden.toggle()
            viewMoreButton.setTitle(morePopularSitesStackView.isHidden ? "查看更多" : "收起", for: .normal)
        })
    }
    
    @objc
    private func siteTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        
        guard tag < popularSites.count else { return }
        let site = popularSites[tag]
        print("Popular site tapped: \(site.name)")
    }
    
    @objc
    private func exampleTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        let resultIndex = index - 1000
        if resultIndex < imsPopularSites.count {}
        // Handle example tap
        print("Example tapped: \(resultIndex)")
    }
}

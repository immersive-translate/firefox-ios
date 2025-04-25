// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct SelectedWebModel {
    var name: String
    var icon: UIImage?
    var url: String
}

struct IMSSelectedWebModel {
    var image: String
    var title: String
    var url: String
}

class IMSWebExampleViewController: BaseViewController {
    var callback: ((String) -> Void)?
    
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
        label.text = "Imt.Localizable.Web.Translation".i18nImt()
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
        imageView.image = UIImage(named: "example_web_finger")
        return imageView
    }()
    
    private lazy var languageIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "toolbar_tranlate_normal")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hexString: "#222222").withDarkColor("D8D8D8")
        return imageView
    }()
    
    private lazy var settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "toolbar_tranlate_setting")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(hexString: "#222222").withDarkColor("D8D8D8")
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = ThemeColor.ZX.c666666
        label.text = "Imt.web.selectedSubtitle".i18nImt()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var popularSitesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "Imt.web.hotSitesTitle".i18nImt()
        return label
    }()
    
    private lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Imt.web.showMore".i18nImt(), for: .normal)
        button.setTitle("Imt.web.hideMore".i18nImt(), for: .selected)
        button.setImage(UIImage(named: "example_arrow_bottom"), for: .normal)
        button.setImage(UIImage(named: "example_arrow_up"), for: .selected)
        button.setTitleColor(ThemeColor.Other.c4181F0, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(viewMoreButtonOnClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var popularSitesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.spacing = 20
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
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private lazy var examplesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "Imt.web.selectedTitle".i18nImt()
        return label
    }()
    
    private lazy var examplesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 22
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
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215417-OgDd2g.jpeg", title: "Far From Ordinary - 2024 Year in Pictures", url: "https://www.nytimes.com/interactive/2024/world/year-in-pictures.html"),
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215434-n42iPa.jpeg", title: "Powell's Message Brings Gloom to Stock Bulls' Party", url: "https://www.bloomberg.com/news/newsletters/2024-12-19/powell-s-message-brings-gloom-to-stock-bulls-party"),
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215441-D6nnHj.jpeg", title: "China's central bank steps up currency support after Fed move", url: "https://asia.nikkei.com/Business/Markets/Currencies/China-s-central-bank-steps-up-currency-support-after-Fed-move"),
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215445-Yb3bHv.jpeg", title: "The Outrage Over 100 Men Only Goes So Far", url: "https://www.theatlantic.com/ideas/archive/2024/12/lily-phillips-outrage-porn-100-men/681032/"),
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215449-a1jHnX.jpeg", title: "How to get a free meal in China", url: "https://www.economist.com/china/2024/12/19/how-to-get-a-free-meal-in-china"),
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/20241221-215558-uXAHrW.png", title: "A Gathering of Ancient Stars", url: "https://www.theatlantic.com/science/archive/2024/12/day-17-2024-space-telescope-advent-calendar-gathering-ancient-stars/681027/"),
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
        bgView.layer.shadowOpacity = 0.1
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
            make.right.equalToSuperview().offset(-31)
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
            make.height.equalTo(99)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        morePopularSitesStackView.backgroundColor = view.backgroundColor
        morePopularSitesStackView.snp.makeConstraints { make in
            make.top.equalTo(popularSitesStackView.snp.bottom)
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
            let exampleView = createExampleView(model: item, index: index + 1000)
            examplesStackView.addArrangedSubview(exampleView)
        }
        
        for (index, site) in popularSites.enumerated() {
            let siteView = createSiteView(site: site, index: index)
            popularSitesStackView.addArrangedSubview(siteView)
        }
        
        for (index, site) in morePopularSites.enumerated() {
            let siteView = createSiteView(site: site, index: index + 100)
            morePopularSitesStackView.addArrangedSubview(siteView)
        }
    }
}

extension IMSWebExampleViewController {
    private func createSiteView(site: SelectedWebModel, index: Int) -> UIView {
        let containerView = UIView()
        containerView.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        let iconImageView = UIImageView()
        iconImageView.image = site.icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 25
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderColor = ThemeColor.TY.c00000008.cgColor
        iconImageView.layer.borderWidth = 1
        
        let nameLabel = UILabel()
        nameLabel.text = site.name
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = ThemeColor.ZX.c333333
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
            make.bottom.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(siteTapped(_ :)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = index
        containerView.isUserInteractionEnabled = true
        
        return containerView
    }

    private func createExampleView(model: IMSSelectedWebModel, index: Int) -> UIView {
        let containerView = UIView()

        let exampleImageView = UIImageView()
        exampleImageView.layer.cornerRadius = 14
        exampleImageView.clipsToBounds = true
        exampleImageView.kf.setImage(with: URL(string: model.image))
        exampleImageView.contentMode = .scaleAspectFill
        exampleImageView.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.text = model.title
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textLabel.textColor = ThemeColor.ZX.c222222
        
        containerView.addSubview(exampleImageView)
        containerView.addSubview(textLabel)
        
        exampleImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(164)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(exampleImageView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exampleTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = index
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
    private func viewMoreButtonOnClick() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.morePopularSitesStackView.snp.updateConstraints { make in
                make.height.equalTo(self.morePopularSitesStackView.isHidden ? 99 : 0)
            }
            self.view.layoutIfNeeded()
        }, completion: { [weak self]  _ in
            guard let self = self else { return }
            morePopularSitesStackView.isHidden.toggle()
            viewMoreButton.isSelected.toggle()
        })
    }
    
    @objc
    private func siteTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        if tag >= 100 {
            guard tag - 100 < morePopularSites.count else { return }
            let site = morePopularSites[tag - 100]
            navigationController?.popViewController(animated: false)
            callback?(site.url)
        } else {
            guard tag < popularSites.count else { return }
            let site = popularSites[tag]
            navigationController?.popViewController(animated: false)
            callback?(site.url)
        }
    }
    
    @objc
    private func exampleTapped(_ gesture: UITapGestureRecognizer) {
        guard let index = gesture.view?.tag else { return }
        let resultIndex = index - 1000
        if resultIndex < imsPopularSites.count {
            let model =  imsPopularSites[resultIndex]
            navigationController?.popViewController(animated: false)
            callback?(model.url)
        }
    }
}

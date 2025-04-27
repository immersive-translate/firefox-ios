// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSSelectedVideoModel {
    var image: String
    var title: String
    var url: String
}

struct SelectedVideoModel {
    var name: String
    var icon: UIImage?
    var url: String
}

class IMSVideoExampleViewController: BaseViewController {
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
        label.text = "Imt.Localizable.Video.Translation".i18nImt()
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
        imageView.image = UIImage(named: "example_video_finger")
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
        label.text = "Imt.video.selectedSubtitle".i18nImt()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private lazy var popularSitesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "Imt.video.hotSitesTitle".i18nImt()
        return label
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
    
    private lazy var examplesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = ThemeColor.ZX.c222222
        label.text = "Imt.video.selectedTitle".i18nImt()
        return label
    }()
    
    private lazy var examplesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 22
        return stackView
    }()
    
    private lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.PP.FDEDF3
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var switchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example_video_switch")
        return imageView
    }()
    
    private lazy var switchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Imt.video.auto".i18nImt()
        label.textColor = ThemeColor.ZX.c333333
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let popularSites: [SelectedVideoModel] = [
        SelectedVideoModel(name: "YouTube", icon: UIImage(named: "example_web_youtube"), url: "https://www.youtube.com"),
        SelectedVideoModel(name: "X", icon: UIImage(named: "example_web_x"), url: "https://x.com"),
        SelectedVideoModel(name: "Udemy", icon: UIImage(named: "example_video_udemy"), url: "https://www.udemy.com"),
        SelectedVideoModel(name: "NEBULA", icon: UIImage(named: "example_video_nebula"), url: "https://nebula.tv/featured"),
    ]
    
    private let imsPopularSites: [IMSSelectedWebModel] = [
        IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/3PS00D-CO273v.png", title: "Powell Speaks After the Fed Cut Rates | The Fed Decides", url: "https://www.youtube.com/watch?v=MLN-Otn5omc"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/IhyLHK-Cy6xfp.png", title: "'Unelected President Musk': Elon posts 70 times trashing GOP bill, Trump caves", url: "https://www.youtube.com/watch?v=UXaVNyXV_CI"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/a3e27l-Qza5au.png", title: "Full interview: Donald Trump details his plans for Day 1 and beyond in the White House", url: "https://www.youtube.com/watch?v=b607aDHUu2I"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/RxP8Rm-ukjnR9.png", title: "Superman - Teaser Trailer Tomorrow", url: "https://www.youtube.com/watch?v=KbE8n146umc"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/TyWgfs-pcMwju.png", title: "KARATE KID: LEGENDS - Official Trailer (HD)", url: "https://www.youtube.com/watch?v=uPzOyzsnmio"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/DVBEYS-VcHUsS.png", title: "Where I've been for the past year...", url: "https://www.youtube.com/watch?v=bgrwYFuNib0"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/6Gkhr8-HjSaL8.png", title: "NL MVP! The BEST MOMENTS from Shohei Ohtani's 2024 season! | 大谷翔平ハイライト", url: "https://www.youtube.com/watch?v=3_gDAF2GzCs"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/ylHsvt-6culPB.png", title: "Real Madrid (ESP) vs Pachuca (MEX) | Intercontinental Cup Final | 12/18/2024 | beIN SPORTS USA", url: "https://www.youtube.com/watch?v=JestHTufnVU"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/37tKJG-CODXms.png", title: "How Employees Are Coffee Badging To Avoid Full Days At The Office", url: "https://www.youtube.com/watch?v=mJG4MdepNSA"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/G9oW2q-M7kB3D.png", title: "The Aston Martin Valkyrie Is a $4.5 Million Insane Hypercar", url: "https://www.youtube.com/watch?v=n68z7e8YGGs"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/DUjf5v-fivcDe.png", title: "Every Home Alone Is Worse Than The Last", url: "https://www.youtube.com/watch?v=oUcE_5Gv_YE"),
          IMSSelectedWebModel(image: "https://s.immersivetranslate.com/assets/uploads/5SFrWM-nXG7KZ.png", title: "Stray Kids \"Walkin On Water\" M/V", url: "https://www.youtube.com/watch?v=ovHoY8UBIu8")
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
        bgView.addSubview(popularSitesStackView)
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
        
        languageIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        settingsImageView.snp.makeConstraints { make in
            make.left.equalTo(languageIconImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        fingerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.top.equalTo(settingsImageView.snp.bottom).offset(-11)
            make.left.equalTo(settingsImageView.snp.right).offset(-15)
        }
        
        tutorialBannerView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
        }
        
        redView.addSubview(switchLabel)
        redView.addSubview(switchImageView)
        switchImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        switchLabel.snp.makeConstraints { make in
            make.right.equalTo(switchImageView.snp.left).offset(-20)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(tutorialBannerView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(31)
            make.right.equalToSuperview().offset(-31)
        }
        
        popularSitesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(24)
        }
        
        popularSitesStackView.snp.makeConstraints { make in
            make.top.equalTo(popularSitesLabel.snp.bottom).offset(16)
            make.height.equalTo(99)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        examplesLabel.snp.makeConstraints { make in
            make.top.equalTo(popularSitesStackView.snp.bottom).offset(8)
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
    }
}

extension IMSVideoExampleViewController {
    private func createSiteView(site: SelectedVideoModel, index: Int) -> UIView {
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

extension IMSVideoExampleViewController {
    @objc
    private func closeButtonOnClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func siteTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        guard tag < popularSites.count else { return }
        let site = popularSites[tag]
        navigationController?.popViewController(animated: false)
        callback?(site.url)
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

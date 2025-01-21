// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


import UIKit

// 功能项视图
class FeatureItemView: UIView {
    private let checkmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "checkmark")
        iv.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(checkmarkImageView)
        addSubview(titleLabel)
        addSubview(infoButton)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 16),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

class ProSubscriptionViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let priceCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "年费Pro会员"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let proTag: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pro"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "¥", attributes: [.font: UIFont.systemFont(ofSize: 16)]))
        text.append(NSAttributedString(string: "48.3", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        text.append(NSAttributedString(string: "/月", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = text
        label.textColor = .white
        return label
    }()
    
    private let yearPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let text = NSMutableAttributedString(string: "¥579.6/年")
        text.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.length))
        label.attributedText = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let saveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "立省248.4元"
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
        return label
    }()
    
    private let limitedTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let limitedTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "限时特惠"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .white
        return imageView
    }()
    
    private let featuresTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pro专属全球顶尖AI翻译服务"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let featuresStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private let yearlyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("连续包年 (节省30%)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let monthlyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("连续包月", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("立即订阅", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFeatures()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // 添加子视图
        containerView.addSubview(priceCardView)
        priceCardView.addSubview(titleLabel)
        priceCardView.addSubview(proTag)
        priceCardView.addSubview(priceLabel)
        priceCardView.addSubview(yearPriceLabel)
        priceCardView.addSubview(saveLabel)
        priceCardView.addSubview(limitedTimeView)
        limitedTimeView.addSubview(clockImageView)
        limitedTimeView.addSubview(limitedTimeLabel)
        
        containerView.addSubview(featuresTitleLabel)
        containerView.addSubview(featuresStackView)
        containerView.addSubview(yearlyButton)
        containerView.addSubview(monthlyButton)
        containerView.addSubview(subscribeButton)
        
        setupConstraints()
    }
    
    private func setupFeatures() {
        let translationFeatures = ["Deepl 翻译", "OpenAI 翻译", "Claude 翻译", "Gemini 翻译"]
        let proFeatures = ["PDF Pro", "Youtube 双语字幕下载", "多设备同步配置", "优先的电子邮件支持"]
        
        translationFeatures.forEach { feature in
            featuresStackView.addArrangedSubview(FeatureItemView(title: feature))
        }
        
        proFeatures.forEach { feature in
            featuresStackView.addArrangedSubview(FeatureItemView(title: feature))
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView 约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Container 约束
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 其他约束保持不变...
            
            // 功能列表约束
            featuresStackView.topAnchor.constraint(equalTo: featuresTitleLabel.bottomAnchor, constant: 16),
            featuresStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            featuresStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 底部按钮约束调整
            yearlyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            yearlyButton.bottomAnchor.constraint(equalTo: subscribeButton.topAnchor, constant: -16),
            yearlyButton.widthAnchor.constraint(equalTo: monthlyButton.widthAnchor),
            yearlyButton.heightAnchor.constraint(equalToConstant: 44),
            
            monthlyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            monthlyButton.centerYAnchor.constraint(equalTo: yearlyButton.centerYAnchor),
            monthlyButton.leadingAnchor.constraint(equalTo: yearlyButton.trailingAnchor, constant: 12),
            monthlyButton.heightAnchor.constraint(equalToConstant: 44),
            
            subscribeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subscribeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            subscribeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            subscribeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

//
//  StarRateView.swift
//  StarRateView


import UIKit

import Foundation

public enum StarType {
    /// 整颗星星
    case `default`
    /// 半颗星星
    case half
    /// 不限制
    case unlimited
}

public class StarRateView: UIView {
    /// 默认整颗星星
    private lazy var starType: StarType = .default

    /// 是否滑动,default is true
    private var isPanEnable = true {
        didSet {
            if isPanEnable {
                /// 滑动手势
                let pan = UIPanGestureRecognizer(target: self, action: #selector(startPan))

                addGestureRecognizer(pan)
            }
        }
    }

    /// 星星的间隔,default is 5.0
    private lazy var starSpace: CGFloat = 5.0

    /// 当前的星星数量,default is 0
    private lazy var currentStarCount: CGFloat = 0

    /// 上次评分
    private lazy var lastScore: CGFloat = -1

    /// 最少星星
    private lazy var leastStar: CGFloat = 0

    /// 星星总数量,default is 5
    private lazy var totalStarCount: CGFloat = 5

    /// 动画时间,default is 0.1
    private lazy var animateDuration = 0.1

    /// 灰色星星视图
    private lazy var unStarView: UIView = .init()

    /// 点亮星星视图
    private lazy var starView: UIView = .init()

    /// 评分回调
    var scoreBlock: ((CGFloat) -> Void)?

    // MARK: - 对象实例化

    override public convenience init(frame: CGRect) {
        self.init(frame: frame, totalStarCount: 5.0, currentStarCount: 0.0, starSpace: 5.0)
    }

    public init(frame: CGRect, totalStarCount: CGFloat, currentStarCount: CGFloat, starSpace: CGFloat) {
        super.init(frame: frame)
        self.totalStarCount = totalStarCount
        self.currentStarCount = currentStarCount
        self.starSpace = starSpace
     
        let tap = UITapGestureRecognizer(target: self, action: #selector(startTap))
        addGestureRecognizer(tap)
        unStarView = setupStarView("feedback_unstar")
        addSubview(unStarView)
        starView = setupStarView("feedback_star")
        insertSubview(starView, aboveSubview: unStarView)
        showStarRate()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CustomMethod

public extension StarRateView {
    func show(type: StarType = .default, isPanEnable: Bool = true, leastStar: CGFloat = 0, completion: @escaping (_ score: CGFloat) -> Void) {
        starType = type
        self.isPanEnable = isPanEnable
        self.leastStar = leastStar
        scoreBlock = completion
    }
}

// MARK: - UI

private extension StarRateView {
    /// 绘制星星UI
    func setupStarView(_ imageName: String) -> UIView {
        let starView = UIView(frame: bounds)
        starView.clipsToBounds = true
        let stackView = UIStackView(frame: bounds)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = starSpace
        starView.addSubview(stackView)
        for _ in 0 ..< Int(totalStarCount) {
            let bundle = Bundle(for: StarRateView.self)

            let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)

            let imageView = UIImageView(image: image)

            stackView.addArrangedSubview(imageView)
        }
        return starView
    }

    /// 显示评分
    func showStarRate() {
        UIView.animate(withDuration: animateDuration, animations: {
            var count = self.currentStarCount
            if count < self.leastStar {
                count = self.leastStar
            }
            let spaceCount = ceil(count)
            let boundsW = self.bounds.width - (self.totalStarCount - 1) * self.starSpace
            let boundsH = self.bounds.height
            var starW: CGFloat = 0
            switch self.starType {
            case .default:
                count = ceil(count)
            case .half:
                count = ceil(count * 2) / 2
            case .unlimited:
                break
            }
            if self.lastScore == count {
                return
            } else {
                self.lastScore = count
            }
            self.scoreBlock?(count)
            starW = count / self.totalStarCount * boundsW + (spaceCount - 1) * self.starSpace
            if starW < 0 {
                starW = 0
            }
            self.starView.frame = CGRect(x: 0, y: 0, width: starW, height: boundsH)
        })
    }
}

// MARK: - 手势交互

extension StarRateView {
    /// 滑动评分
    @objc func startPan(_ pan: UIPanGestureRecognizer) {
        var offX: CGFloat = 0

        if pan.state == .began {
            offX = pan.location(in: self).x
        } else if pan.state == .changed {
            offX += pan.location(in: self).x
        } else {
            return
        }

        if offX < 0 {
            offX = 0
        }

        if offX > bounds.maxX {
            offX = bounds.maxX
        }

        currentStarCount = offX / bounds.width * totalStarCount

        showStarRate()
    }

    /// 点击评分
    @objc func startTap(_ tap: UITapGestureRecognizer) {
        let offX = tap.location(in: self).x

        currentStarCount = offX / bounds.width * totalStarCount

        showStarRate()
    }
}

//
//  NCAlertController.swift
//  NCInterviewReply
//
//  Created by yuanchao on 2022/6/20.
//

import UIKit

class NCAlertController: UIViewController {
    var contentView: UIView?

    var isShow = false

    var showAnimation: (() -> Void)?

    var dismissAnimation: (() -> Void)?

    public init(contentView: UIView? = nil, showAnimation: (() -> Void)? = nil, dismissAnimation: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve

        self.contentView = contentView
        self.showAnimation = showAnimation
        self.dismissAnimation = dismissAnimation
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let contentView = contentView, !isShow {
            view.addSubview(contentView)
            isShow = true
            showAnimation?()
        }
    }
}

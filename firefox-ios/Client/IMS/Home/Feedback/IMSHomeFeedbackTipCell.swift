// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import AttributedString

class IMSHomeFeedbackTipCell: UICollectionViewCell, ReusableCell {
    
    private var textColor: UIColor?
    
    private lazy var feedbackView: IMSHomeFeedbackView = {
        let view = IMSHomeFeedbackView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.addSubview(feedbackView)
        feedbackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(23)
            make.right.equalToSuperview().offset(-23)
            make.height.equalTo(140)
        }
    }
}

extension IMSHomeFeedbackTipCell: ThemeApplicable {
    func applyTheme(theme: Theme) {
      
    }
}

extension IMSHomeFeedbackTipCell {
    func configure(theme: Theme, textColor: UIColor?) {
        self.textColor = textColor
        applyTheme(theme: theme)
    }
}

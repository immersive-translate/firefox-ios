// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

class VerificationCodeTextField: InputTextField {
    var callback: ((_ complete: @escaping (Bool) -> Void) -> Void)?
    
    private lazy var countdownLabel: UILabel = {
        let button = UILabel()
        button.text = "Imt.email_login.reset_verify_code_btn".i18nImt()
        button.textColor = ThemeColor.Other.c4181F0
        button.font = .systemFont(ofSize: 14)
        button.textAlignment = .center
        button.addTapGesture { [weak self] _ in
            self?.sendCodeButtonTapped()
        }
        return button
    }()
    
 
    private var timer: Timer?
    private var countdown = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        let linView = UIView()
        linView.backgroundColor = ThemeColor.TC.ECF0F7
        
        let tempView = UIView()
        tempView.snp.makeConstraints { make in
            make.width.equalTo(91)
            make.height.equalTo(28)
        }
        tempView.addSubview(countdownLabel)
        countdownLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(1)
            make.height.equalTo(21)
        }
        tempView.addSubview(linView)
        linView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }
        
        rightView = tempView
        rightViewMode = .always
    }
    

    @objc
    private func sendCodeButtonTapped() {
        callback? { [weak self] success in
            guard let self = self else { return }
            if success {
                startCountdown()
            }
        }
    }
    
    func startCountdown() {
        countdownLabel.textColor = ThemeColor.Other.A0C0F8
        countdown = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.countdown > 0 {
                self.countdown -= 1
                DispatchQueue.main.async {
                    self.countdownLabel.text = "\(self.countdown)s"
                }
            } else {
                self.stopCountdown()
            }
        }
        timer?.fire()
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        countdown = 60
        countdownLabel.textColor = ThemeColor.Other.c4181F0
        countdownLabel.text = "Imt.email_login.reset_verify_code_btn".i18nImt()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

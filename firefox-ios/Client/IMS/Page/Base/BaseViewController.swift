// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

class BaseViewController: UIViewController {
    var isNavigationBarHidden: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor.ZX.FFFFFF
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavigationBarHidden = navigationController?.isNavigationBarHidden
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let isNavigationBarHidden = isNavigationBarHidden {
            navigationController?.isNavigationBarHidden = isNavigationBarHidden
        }
    }
    
    var showBottomLine: Bool {
        return true
    }
    
    private func setup() {
        let backButtonImage = UIImage(named: "nav_back")?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0))
        let appearance = UINavigationBarAppearance()
        if !showBottomLine {
            appearance.shadowColor = .clear
        }
        appearance.backgroundColor = view.backgroundColor
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeColor.ZX.c222222]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = ThemeColor.ZX.c222222
    }
}

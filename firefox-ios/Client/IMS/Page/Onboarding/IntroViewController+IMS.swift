// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension IntroViewController {
    @_dynamicReplacement(for: setupPageController)
    func ims_setupPageController() {
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -8),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
        ])
        pageControl.hidesForSinglePage = true
        
        
    }
}

// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import UIKit


extension HomeLogoHeaderCell {
    @_dynamicReplacement(for: setupView(with:))
    func ims_setupView(with showiPadSetup: Bool) {
        contentView.backgroundColor = .clear
        logoText.text = "看见更大的世界"
        logoText.font = .systemFont(ofSize: 20, weight: .bold)
//        logoText.setContentCompressionResistancePriority(.required, for: .horizontal)
        containerView.addArrangedSubview(logoImage)
        containerView.addArrangedSubview(logoText)
        contentView.addSubview(containerView)

        containerView.spacing = HomeLogoHeaderCell.UX.TextImage.textImageSpacing(for: showiPadSetup)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])

        NSLayoutConstraint.deactivate(logoConstraints)
        logoConstraints = [
            logoImage.widthAnchor.constraint(equalToConstant: HomeLogoHeaderCell.UX.Logo.logoSizeConstant(for: showiPadSetup)),
            logoImage.heightAnchor.constraint(equalToConstant: HomeLogoHeaderCell.UX.Logo.logoSizeConstant(for: showiPadSetup)),
//            logoText.widthAnchor.constraint(equalToConstant: HomeLogoHeaderCell.UX.TextImage.textImageWidthConstant(for: showiPadSetup)),
            logoText.heightAnchor.constraint(equalTo: logoImage.heightAnchor),
        ]
        NSLayoutConstraint.activate(logoConstraints)
    }
}

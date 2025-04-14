// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Foundation
import UIKit
import Common


extension LegacyHomepageHeaderCell {
    @_dynamicReplacement(for: setupConstraints(for:))
    func ims_setupConstraints(for iPadSetup: Bool) {
        NSLayoutConstraint.deactivate(logoConstraints)
        privateModeButton.isHidden = true
        privateModeButton.isEnabled = false
        logoHeaderCell.isHidden = true
        
        let topAnchorConstant = iPadSetup ? UX.iPadTopConstant : UX.iPhoneTopConstant
        logoConstraints = [
            stackContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topAnchorConstant),
            stackContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).priority(.defaultLow),
            
            privateModeButton.widthAnchor.constraint(equalToConstant: UX.circleSize.width),
            privateModeButton.centerYAnchor.constraint(equalTo: stackContainer.centerYAnchor),
            logoHeaderCell.contentView.centerYAnchor.constraint(equalTo: stackContainer.centerYAnchor)
        ]

        NSLayoutConstraint.activate(logoConstraints)
    }
    
    @_dynamicReplacement(for: configure(with:))
    func ims_configure(with viewModel: HomepageHeaderCellViewModel) {
        self.configure(with: viewModel)
        self.privateModeButton.isHidden = true
    }
}

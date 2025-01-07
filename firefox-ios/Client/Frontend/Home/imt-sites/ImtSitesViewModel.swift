// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared

class ImtSitesViewModel {
    struct UX {
        static let bottomSpacing: CGFloat = 30
    }

    private let profile: Profile
    var itemHandler: ((URL) -> Void)?

    var onTapAction: ((UIButton) -> Void)?
    var theme: Theme

    init(profile: Profile, theme: Theme) {
        self.profile = profile
        self.theme = theme
    }
}

// MARK: HomeViewModelProtocol
extension ImtSitesViewModel: HomepageViewModelProtocol, FeatureFlaggable {
    var sectionType: HomepageSectionType {
        return .imtSites
    }

    var headerViewModel: LabelButtonHeaderViewModel {
        return .emptyHeader
    }

    func section(for traitCollection: UITraitCollection, size: CGSize) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(ImtSitesCell.height()))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(ImtSitesCell.height()))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)

        let horizontalInset = HomepageViewModel.UX.leadingInset(traitCollection: traitCollection)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: horizontalInset,
                                                        bottom: HomepageViewModel.UX.spacingBetweenSections,
                                                        trailing: horizontalInset)

        return section
    }

    func numberOfItemsInSection() -> Int {
        return 1
    }

    var isEnabled: Bool {
        return false
    }

    func setTheme(theme: Theme) {
        self.theme = theme
    }
}

extension ImtSitesViewModel: HomepageSectionHandler {
    func configure(_ cell: UICollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let imtSitesCell = cell as? ImtSitesCell else { return UICollectionViewCell() }
        imtSitesCell.applyTheme(theme: theme)
        imtSitesCell.configure(viewModel: self, theme: theme)
        return imtSitesCell
    }
}

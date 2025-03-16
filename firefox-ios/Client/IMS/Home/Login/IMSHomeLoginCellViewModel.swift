// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import Storage

class IMSHomeLoginCellViewModel {
    var theme: Theme
    var loginHandler: (() -> Void)?
    private var wallpaperManager: WallpaperManager

    init(theme: any Theme, wallpaperManager: WallpaperManager) {
        self.theme = theme
        self.wallpaperManager = wallpaperManager
    }
    
    var showFeedback: Bool {
        return !StoreConfig.alreadyShowFeedbackTip && StoreConfig.translateNum > 3
    }
}

extension IMSHomeLoginCellViewModel: HomepageViewModelProtocol {
    var sectionType: HomepageSectionType {
        return .imsLogin
    }

    func section(for traitCollection: UITraitCollection, size: CGSize) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(showFeedback ? 140 + 35 : 50)
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func numberOfItemsInSection() -> Int {
        return 1
    }

    var headerViewModel: LabelButtonHeaderViewModel {
        return LabelButtonHeaderViewModel.emptyHeader
    }

    var isEnabled: Bool {
        if showFeedback {
            return true
        }
        if let _ = IMSAccountManager.shard.current() {
            return false
        } else {
            return true
        }
    }

    func setTheme(theme: any Common.Theme) {
        self.theme = theme
    }
}

extension IMSHomeLoginCellViewModel: HomepageSectionHandler {
    func configure(_ cell: UICollectionViewCell, at indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func configure(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: IMSHomeLoginCell.self, for: indexPath)!
        let textColor = wallpaperManager.currentWallpaper.textColor
        cell.configure(theme: theme, textColor: textColor)
        cell.changeFeedback(showFeedback: showFeedback)
        cell.loginHandler = loginHandler
        return cell
    }
}

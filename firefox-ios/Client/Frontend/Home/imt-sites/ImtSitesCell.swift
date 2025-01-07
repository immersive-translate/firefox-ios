// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import Foundation
import Shared
import UIKit

class ImtSitesCell: UICollectionViewCell, ReusableCell {
    private struct UX {
        static let itemImageViewSize: CGSize = CGSizeMake(60, 60)
        static let itemLabelTopMargin: CGFloat = 5
        static let itemLabelFontSize: CGFloat = 12
        static let cellVerticalPadding: CGFloat = 20

    }

    private var viewModel: ImtSitesViewModel?
    
    private var validLabels: [UILabel] = []

    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    func setupView() {
        contentView.backgroundColor = .clear
        let webItemView = createLogoAndDescView(imageName: "web-intro", desc: .ImtLocalizableWebTranslation, invalid: false)
        let webTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(webClick))
        webItemView.isUserInteractionEnabled = true;
        webItemView.addGestureRecognizer(webTapRecognizer)
        contentView.addSubview(webItemView);
        
        let videoItemView = createLogoAndDescView(imageName: "video-intro", desc: .ImtLocalizableVideoTranslation, invalid: false)
        let videoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoClick))
        videoItemView.isUserInteractionEnabled = true;
        videoItemView.addGestureRecognizer(videoTapRecognizer)
        contentView.addSubview(videoItemView);

        let documentItemView = createLogoAndDescView(imageName: "document-intro", desc: .ImtLocalizableDocTranslation, invalid: false)
        let documentTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(documentClick))
        documentItemView.isUserInteractionEnabled = true;
        documentItemView.addGestureRecognizer(documentTapRecognizer)
        contentView.addSubview(documentItemView);
        
        let cartoonItemView = createLogoAndDescView(imageName: "cartoon-intro", desc: .ImtLocalizableComicTranslation, invalid: false)
        let cartoonTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cartoonClick))
        cartoonItemView.isUserInteractionEnabled = true;
        cartoonItemView.addGestureRecognizer(cartoonTapRecognizer)
        contentView.addSubview(cartoonItemView);
        
//        let moreItemView = createLogoAndDescView(imageName: "expect-intro", desc: "更多工具", invalid: true)
//        let moreTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(moreClick))
//        moreItemView.isUserInteractionEnabled = true;
//        moreItemView.addGestureRecognizer(moreTapRecognizer)
//        contentView.addSubview(moreItemView);
        
        let itemMargin = (self.frame.size.width - 4 * UX.itemImageViewSize.width) / 3

        NSLayoutConstraint.activate([
            webItemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UX.cellVerticalPadding),
            webItemView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            videoItemView.leftAnchor.constraint(equalTo: webItemView.rightAnchor, constant: itemMargin),
            videoItemView.topAnchor.constraint(equalTo: webItemView.topAnchor),
            documentItemView.leftAnchor.constraint(equalTo: videoItemView.rightAnchor, constant: itemMargin),
            documentItemView.topAnchor.constraint(equalTo: webItemView.topAnchor),
            cartoonItemView.leftAnchor.constraint(equalTo: documentItemView.rightAnchor, constant: itemMargin),
            cartoonItemView.topAnchor.constraint(equalTo: webItemView.topAnchor),
//            moreItemView.topAnchor.constraint(equalTo: webItemView.bottomAnchor, constant: UX.cellVerticalPadding),
//            moreItemView.leftAnchor.constraint(equalTo: webItemView.leftAnchor),
            webItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UX.cellVerticalPadding),
        ])
    }
    
    func createLogoAndDescView(imageName: String, desc: String, invalid: Bool) -> UIView {
        let itemView = UIView();
        itemView.translatesAutoresizingMaskIntoConstraints = false;
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill;
        imageView.image = UIImage(imageLiteralResourceName: imageName)
        itemView.addSubview(imageView);
        
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UX.itemLabelFontSize);
        label.text = desc
        label.textColor = UIColor(colorString: invalid ? "999999" : "222222")
        itemView.addSubview(label)
        if (!invalid) {
            validLabels.append(label)
        }
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: UX.itemImageViewSize.width),
            imageView.heightAnchor.constraint(equalToConstant: UX.itemImageViewSize.height),
            imageView.leftAnchor.constraint(equalTo: itemView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: itemView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UX.itemLabelTopMargin),
            label.bottomAnchor.constraint(equalTo: itemView.bottomAnchor),
        ])
        return itemView
    }
    
    
    func configure(viewModel: ImtSitesViewModel, theme: Theme) {
        self.viewModel = viewModel
    }
    
    @objc func webClick() {
        seeWeb(url: "https://test-browser.immersivetranslate.com/web")
    }
    
    @objc func videoClick() {
        seeWeb(url: "https://test-browser.immersivetranslate.com/video")
    }
    
    @objc func documentClick() {
        seeWeb(url: "https://app.immersivetranslate.com")
    }
    
    @objc func cartoonClick() {
        seeWeb(url: "https://test-browser.immersivetranslate.com/manga")
    }
    
    @objc func moreClick() {
        
    }
    
    func seeWeb(url: String) {
        if let handler = self.viewModel?.itemHandler {
            handler(URL(string: url)!)
        }
    }
    
    static func height() -> CGFloat {
        return UX.itemImageViewSize.height + UX.itemLabelTopMargin + UX.itemLabelFontSize
    }
}

// MARK: - ThemeApplicable
extension ImtSitesCell: ThemeApplicable {
    func applyTheme(theme: Theme) {
        let wallpaperManager = WallpaperManager()
        var textColor: UIColor!;
        if let logoTextColor = wallpaperManager.currentWallpaper.logoTextColor {
            textColor = logoTextColor
        } else {
            textColor = theme.colors.textPrimary
        }
        validLabels.forEach { label in
            label.textColor = textColor
        }
    }
}

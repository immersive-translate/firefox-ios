// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

enum IMSImageContextMenuType {
    case unTranslate
    case translate
    case save
    case copy
    case share
    case feedback
    
    var icon: UIImage? {
        switch self {
        case .unTranslate:
            return UIImage(named: "imageContextMenu_translate_cancel")
        case .translate:
            return UIImage(named: "imageContextMenu_translate")
        case .save:
            return UIImage(named: "imageContextMenu_save")
        case .copy:
            return UIImage(named: "imageContextMenu_copy")
        case .share:
            return UIImage(named: "imageContextMenu_share")
        case .feedback:
            return UIImage(named: "imageContextMenu_feedback")
        }
    }
    
    var title: String {
        switch self {
        case .unTranslate:
            return "Imt.imageContextMenu.unTranslate".i18nImt()
        case .translate:
            return "Imt.imageContextMenu.translate".i18nImt()
        case .save:
            return "Imt.imageContextMenu.save".i18nImt()
        case .copy:
            return "Imt.imageContextMenu.copy".i18nImt()
        case .share:
            return "Imt.imageContextMenu.share".i18nImt()
        case .feedback:
            return "Imt.imageContextMenu.feedback".i18nImt()
        }
    }
}

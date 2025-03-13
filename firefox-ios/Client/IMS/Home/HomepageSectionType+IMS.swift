// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/
import Common
import Foundation

extension HomepageSectionType {
    @_dynamicReplacement(for: cellIdentifier)
    var ims_cellIdentifier: String {
        let origin = self.cellIdentifier
        if self == .imsTopSites {
            return ""
        } else if self == .imsLogin {
            return IMSHomeLoginCell.cellIdentifier
        } else if self == .imsFeedback {
            return IMSHomeFeedbackCell.cellIdentifier
        }
        return origin
    }
    
    @_dynamicReplacement(for: cellTypes)
    static var ims_cellTypes: [ReusableCell.Type] {
        var origin = self.cellTypes
        origin.append(IMSTopSiteItemCell.self)
        origin.append(IMSHomeLoginCell.self)
        origin.append(IMSHomeFeedbackCell.self)
        return origin
    }
}

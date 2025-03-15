// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension SVProgressHUD {
    static func toast(_ string: String?) {
        setImageViewSize(.zero)
        showInfo(withStatus: string)
    }
    
    static func success(_ string: String?) {
        setImageViewSize(CGSize(width: 28, height: 28))
        showSuccess(withStatus: string)
    }
    
    
    static func error(_ string: String?) {
        setImageViewSize(CGSize(width: 28, height: 28))
        showError(withStatus: string)
    }
}

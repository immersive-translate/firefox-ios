// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension UIColor {
    func withDarkColor(_ dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : self
        }
    }

    func withDarkColor(_ dark: String) -> UIColor {
        return withDarkColor(UIColor(hexString: dark))
    }
}

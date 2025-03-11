// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

extension URL {
    public static var mozBundleVersion: String = {
        guard let string = Bundle.main.object(
            forInfoDictionaryKey: "MozBundleVersion"
        ) as? String, !string.isEmpty else {
            // Something went wrong/weird, fall back to hard-coded.
            return "firefox"
        }
        return string
    }()
}

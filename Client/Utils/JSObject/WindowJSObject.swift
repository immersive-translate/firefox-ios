// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation


class WindowJSObject {
    
    var openBlock: (_ url: String) -> ()
    
    init(openBlock: @escaping (_: String) -> Void) {
        self.openBlock = openBlock
    }

    @objc func open( _ params: [String: String] ) {
        openBlock(params["url"] ?? "")
    }
}

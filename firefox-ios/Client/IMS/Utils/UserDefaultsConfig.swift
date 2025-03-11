// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import LTXiOSUtils

enum UserDefaultsConfig {

    @UserDefaultsWrapper("SHOW_DEBUG_TOOL", defaultValue: false)
    static var showDebugTool: Bool
    
    @UserDefaultsWrapper("NETWORK_ENV_STR", defaultValue: "")
    static var networkEnvStr: String

    @UserDefaultsWrapper("SHOW_DEBUG_LOG", defaultValue: false)
    static var debugLog: Bool
}

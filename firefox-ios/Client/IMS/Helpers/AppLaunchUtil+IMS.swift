// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import ObjectiveC.runtime
import Adjust

extension AppLaunchUtil {
    
    struct AppLaunchUtilHolder {
        static var AdjustHolderKey: UInt8 = 0
    }
    
    var adjustHelper: AdjustHelper? {
        get {
            objc_getAssociatedObject(self, &AppLaunchUtilHolder.AdjustHolderKey) as? AdjustHelper
        }
        set {
            objc_setAssociatedObject(self, &AppLaunchUtilHolder.AdjustHolderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @_dynamicReplacement(for: afterInit)
    func ims_afterInit() {
        let adjustHelper = AdjustHelper(profile: profile)
        self.adjustHelper = adjustHelper
    }
    
    @_dynamicReplacement(for: setUpPostLaunchDependencies)
    func ims_setUpPostLaunchDependencies() {
        self.setUpPostLaunchDependencies()
        adjustHelper?.setupAdjust()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Adjust.requestTrackingAuthorization { status in
                print("requestTrackingAuthorization: \(status)")
            }
        }
    }
}

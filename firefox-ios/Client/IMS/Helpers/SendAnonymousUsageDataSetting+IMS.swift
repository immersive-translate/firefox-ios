// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

//extension SendAnonymousUsageDataSetting {
//    @_dynamicReplacement(for: setupSettingDidChange)
//    func ims_setupSettingDidChange() {
//        self.settingDidChange = { [weak self] value in
//            AdjustHelper.setEnabled(value)
//            DefaultGleanWrapper.shared.setUpload(isEnabled: value)
//            Experiments.setTelemetrySetting(value)
//            self?.shouldSendUsageData?(value)
//        }
//    }
//}

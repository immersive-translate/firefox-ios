// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/



struct IMSAPPConfig: Codable {
    @DefaultEmptyArray
    var appHostWhiteList: [String] = []
}



final class IMSAPPConfigUtils {
    
    static let shared = IMSAPPConfigUtils()
    
    private init() {}
    
    private var _config: IMSAPPConfig?
    
    var config: IMSAPPConfig {
        if let config = _config {
            return config
        }
        if StoreConfig.appConfig.isNotEmpty {
            guard let data = StoreConfig.appConfig.data(using: .utf8) else { return IMSAPPConfig() }
            if let config = try? JSONDecoder().decode(IMSAPPConfig.self, from: data) {
                _config = config
                return config
            } else {
                return IMSAPPConfig()
            }
        }
        return IMSAPPConfig()
    }
}


extension IMSAPPConfigUtils {
    func refresh() {
        APIService.sendRequest(APPAPI.GlobalConfigRequest()) { response in
            switch response.result.validateResult {
            case let .success(info):
                self._config = info
                if let data = try? JSONEncoder().encode(info), let jsonString = String(data: data, encoding: .utf8) {
                    StoreConfig.appConfig = jsonString
                }
            case .failure:
                ()
            }
        }
    }
}

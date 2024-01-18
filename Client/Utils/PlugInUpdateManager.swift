// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import Alamofire

extension Notification.Name {
    public static let NeedRefreshImmersiveTranslateJsInject = Notification.Name("NeedRefreshImmersiveTranslateJsInject")
}

class PlugInUpdateManager {
    public static let shared = PlugInUpdateManager()
    private static let url = "https://download.immersivetranslate.com/immersive-translate.user.js";
    private static let resouceNameCacheKey = "resouceNameCacheKey";
    private static let resouceEtagCacheKey = "resouceEtagCacheKey";
    private let cacheDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0];
    private let jsBundleUrlString = Bundle.main.path(
        forResource: "immersive-translate.user", ofType: "js")!
    private let jsBundleEtag = ##"W/"82bc73bea505b38a7d592bd53ee97572""##;
    
    var currentResourceLocation: String {
        if let currentResourceName = UserDefaults.standard.string(forKey: PlugInUpdateManager.resouceNameCacheKey)  {
            let currentResourceLocation = self.cacheDirectory.appendingPathComponent(currentResourceName).path;
            if  FileManager.default.fileExists(atPath:currentResourceLocation) {
                return currentResourceLocation;
            }
        }
        return jsBundleUrlString;
    }
        
    var currentEtag: String {
        if let currentEtag = UserDefaults.standard.string(forKey: PlugInUpdateManager.resouceEtagCacheKey)  {
            return currentEtag;
        }
        return jsBundleEtag;
    }
    
    func checkUpdate() {
        AF.request(PlugInUpdateManager.url, method: .head, parameters: nil).validate().responseString(encoding: .utf8) { response in
            if let headers = response.response?.headers.dictionary {
                if response.error == nil, let etag = headers["Etag"], etag != self.currentEtag {
                    self.download();
                }
            }
        }
    }
    
    func download()  {
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0];
        var currentResourceLocationUrl:URL?
        let firstCacheName = "immersive-translate-first.js";
        let secondCacheName = "immersive-translate-second.js";
        if let currentResourceName = UserDefaults.standard.string(forKey: PlugInUpdateManager.resouceNameCacheKey), currentResourceName == firstCacheName {
            currentResourceLocationUrl = self.cacheDirectory.appendingPathComponent(secondCacheName);
        } else {
            currentResourceLocationUrl = self.cacheDirectory.appendingPathComponent(firstCacheName);
        }
        let destination: DownloadRequest.Destination = { _, _ in
            return (currentResourceLocationUrl!, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(PlugInUpdateManager.url, to: destination).validate().response { response in
            if response.error == nil, let path = response.fileURL?.path, FileManager.default.fileExists(atPath: path), let etag = response.response?.headers.dictionary["Etag"] {
                let name = path.split(separator: "/").last;
                UserDefaults.standard.setValue(name, forKey: PlugInUpdateManager.resouceNameCacheKey);
                UserDefaults.standard.setValue(etag, forKey: PlugInUpdateManager.resouceEtagCacheKey);
                UserDefaults.standard.synchronize();
                NotificationCenter.default.post(name: .NeedRefreshImmersiveTranslateJsInject, object: nil);
            }
        }
    }
}

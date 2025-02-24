// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct IMSTopLinkContent: Codable {
    let topLinks: [IMSTopLink]
}

struct IMSTopLink: Codable {
    let id: Int
    let iconUrl: String
    let linkUrl: String
    let titleZh: String
    let titleTr: String
    let titleEn: String
    let titleKo: String
    
    // 自定义编码键，处理 JSON 中的下划线命名
    enum CodingKeys: String, CodingKey {
        case id
        case iconUrl
        case linkUrl
        case titleZh = "title_zh"
        case titleTr = "title_tr"
        case titleEn = "title_en"
        case titleKo = "title_ko"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 解码必需的字段
        id = try container.decode(Int.self, forKey: .id)
        iconUrl = try container.decode(String.self, forKey: .iconUrl)
        linkUrl = try container.decode(String.self, forKey: .linkUrl)
        titleZh = try container.decode(String.self, forKey: .titleZh)
        titleTr = try container.decode(String.self, forKey: .titleTr)
        titleEn = try container.decode(String.self, forKey: .titleEn)
        
        // 自定义解码 titleKo
        if let koreanTitle = try container.decodeIfPresent(String.self, forKey: .titleKo),
           !koreanTitle.isEmpty {
            titleKo = koreanTitle
        } else {
            titleKo = titleEn
        }
    }
}

class IMSAPPTopSiteService {
    private var topSites: [TopSite] = []
    static let kIMSTopSiteStoreKey: String = "kIMSTopSiteStoreKey"
    
    init() {
        topSites = [
            .init(site: .init(url: "https://browser.immersivetranslate.com/web", title: .ImtLocalizableWebTranslation, bookmarked: false, faviconResource: .bundleAsset(name: "web-intro", forRemoteResource: Bundle.main.bundleURL))),
            .init(site: .init(url: "https://browser.immersivetranslate.com/video", title: .ImtLocalizableVideoTranslation, bookmarked: false, faviconResource: .bundleAsset(name: "video-intro", forRemoteResource: Bundle.main.bundleURL))),
            .init(site: .init(url: "https://app.immersivetranslate.com", title: .ImtLocalizableIntroDocument, bookmarked: false, faviconResource: .bundleAsset(name: "document-intro", forRemoteResource: Bundle.main.bundleURL))),
            .init(site: .init(url: "https://browser.immersivetranslate.com/manga", title: .ImtLocalizableComicTranslation, bookmarked: false, faviconResource: .bundleAsset(name: "cartoon-intro", forRemoteResource: Bundle.main.bundleURL))),
            .init(site: .init(url: "https://browser.immersivetranslate.com/xiaohongshu", title: .ImtLocalizableXiaohongshuTranslation, bookmarked: false, faviconResource: .bundleAsset(name: "xiaohongshu-intro", forRemoteResource: Bundle.main.bundleURL))),
            .init(site: .init(url: "https://bilin.ai/zh", title: .ImtLocalizableBiLinSearch, bookmarked: false, faviconResource: .bundleAsset(name: "BiLinSearch-intro", forRemoteResource: Bundle.main.bundleURL)))
        ]
        
        updateFromStore()
    }
    
    func getTopSites() -> [TopSite] {
        self.update()
        return self.topSites
    }
    
    func update() {
        Task {
            if let ret = await self.fetchFromRemote() {
                let content = ret.data
                await MainActor.run {
                    self.setStore(content: content)
                    self.updateFromStore()
                }
            }
        }
    }
    
    func updateFromStore() {
        if let content = self.getStore() {
            let topSites = self.convertStoreContentToTopSite(content: content)
            self.topSites = topSites
        }
    }
    
    func convertStoreContentToTopSite(content: IMSTopLinkContent) -> [TopSite] {
        var topSites: [TopSite] = []
        var jsonName = "en"
        if let preferredLocalizations = NSLocale.preferredLanguages.first {
            if (preferredLocalizations.contains("zh-Hans")) {
                jsonName = "zh-CN"
            } else if (preferredLocalizations.contains("zh-Hant")) {
                jsonName = "zh-TW"
            } else if (preferredLocalizations.contains("ko")) {
                jsonName = "ko"
            }
        }
        for topLinks in content.topLinks {
            let title = if jsonName == "zh-CN" {
                topLinks.titleZh
            } else if jsonName == "zh-TW" {
                topLinks.titleTr
            } else if jsonName == "ko" {
                topLinks.titleKo
            } else {
                topLinks.titleEn
            }
            let iconUrl = URL(string: topLinks.iconUrl) ?? URL(string: "")!
            let topSite: TopSite = .init(site: .init(url: topLinks.linkUrl, title: title, bookmarked: false, faviconResource: .remoteURL(url: iconUrl)))
            topSites.append(topSite)
            
        }
        return topSites
    }
    
    func fetchFromRemote() async -> IMSHttpResponse<IMSTopLinkContent>?{
        guard let url = URL(string: IMSAppUrlConfig.baseAPIURL + "/v1/app-home/toplinks") else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        // 设置请求头
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        urlRequest.setValue("zh-CN,zh;q=0.9,en;q=0.8", forHTTPHeaderField: "Accept-Language")
        urlRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return nil
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                return nil
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(IMSHttpResponse<IMSTopLinkContent>.self, from: data)
        } catch {
            return nil
        }
    }
    
    func setStore(content: IMSTopLinkContent) {
        guard let data = try? JSONEncoder().encode(content) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: Self.kIMSTopSiteStoreKey)
    }
    
    func getStore() -> IMSTopLinkContent? {
        guard let data = UserDefaults.standard.data(forKey: Self.kIMSTopSiteStoreKey) else {
            return nil
        }
        let content = try? JSONDecoder().decode(IMSTopLinkContent.self, from: data)
        return content
    }
    
    
}

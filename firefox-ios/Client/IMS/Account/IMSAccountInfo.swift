// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/


struct IMSAccountInfo: Codable {
    let subscription: String?
    let totalTrialMathPixQuota: Int
    let trialMathPixUsedCount: Int
    let weChatPackageMathPixQuota: Int?
    let weChatPackageMathPixQuotaUsedCount: Int?
    let hasPhone: Bool
    let myPhone: String?
    let hasBindWeChat: Bool
    let weChatNickName: String?
    let weChatAvatarUrl: String?
    let userName: String
    let email: String
    let nickName: String
    let lastLoginTime: String
    let openId: String
    let deviceId: String?
    let accountType: String
    let uid: Int
    let `operator`: String
    let updateTime: String?
    let createTime: String
    let isDeleted: Bool
    let dataVersion: Int
    let id: Int
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case subscription
        case totalTrialMathPixQuota
        case trialMathPixUsedCount
        case weChatPackageMathPixQuota
        case weChatPackageMathPixQuotaUsedCount
        case hasPhone
        case myPhone
        case hasBindWeChat
        case weChatNickName
        case weChatAvatarUrl
        case userName
        case email
        case nickName
        case lastLoginTime
        case openId
        case deviceId
        case accountType
        case uid
        case `operator`
        case updateTime
        case createTime
        case isDeleted
        case dataVersion
        case id
        case token
    }
    
}
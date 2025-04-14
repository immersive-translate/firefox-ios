// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

struct LoginResult: Codable {
    @DefaultEmptyString
    var redirectTo: String = ""
    
    @DefaultEmptyString
    var token: String = ""
    
    var user: IMSUser?
}

struct IMSUser: Codable {
    @DefaultEmptyString
    var token: String
    
    @DefaultEmptyString
    var email: String
    
    @DefaultIntZero
    var uid: Int
    
    @DefaultEmptyString
    var nickName: String
    
    @DefaultEmptyString
    var accountType: String
    
    @DefaultEmptyString
    var iosPlanTier: String
    
    @DefaultEmptyString
    var userName: String
}

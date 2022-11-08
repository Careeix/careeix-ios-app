//
//  User.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/03.
//

import Foundation

struct User: Codable {
    var jwt: String
    var message: String
    let userId: Int
    let userJob: String
    let userDetailJobs: [String]
    let userWork: Int
    let userNickname: String
    let userProfileImg: String?
    let userProfileColor: String
    let userIntro: String?
    let userSocialProvider: Int
    
    init(jwt: String,
         message: String,
         userId: Int = 0,
         userJob: String = "",
         userDetailJobs: [String] = [],
         userWork: Int = 0,
         userNickname: String = "",
         userProfileImg: String? = nil,
         userProfileColor: String = "",
         userIntro: String? = nil,
         userSocialProvider: Int = 0) {
        self.jwt = jwt
        self.message = message
        self.userId = userId
        self.userJob = userJob
        self.userDetailJobs = userDetailJobs
        self.userWork = userWork
        self.userNickname = userNickname
        self.userProfileImg = userProfileImg
        self.userProfileColor = userProfileColor
        self.userIntro = userIntro
        self.userSocialProvider = userSocialProvider
    }
}

//
//  UserEntity.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/07.
//

import Foundation

extension Entity {
    enum LoginUser {
        struct Response: Codable {
            let jwt: String
            let message: String
            let userId: Int
            let userJob: String
            let userDetailJobs: [String]
            let userWork: Int
            let userNickname: String
            let userProfileImg: String
            let userProfileColor: String
            let userIntro: String
            let userSocialProvider: Int
        }
    }
    
    enum SignUpUser {
        struct Request {
            let nickname: String
            let job: String
            let annual: Int
            let detailJobs: [String]
        }
        struct Response {
            let jwt: String
            let message: String
            let userId: Int
            let userJob: String
            let userDetailJobs: [String]
            let userWork: Int
            let userNickname: String
            let userProfileImg: String?
            let userProfileColor: String
            let userIntro: String
            let userSocialProvider: Int?
        }
    }
}

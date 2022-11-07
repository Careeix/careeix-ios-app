//
//  UserDTO.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/06.
//

import Foundation

extension DTO {
    enum User {
        struct Request: Encodable {
            var token: String
            var job: String
            var nickname: String
            var userDetailJob: [String]
            var userWork: Int
        }
        
        struct Response: Codable {
            let jwt: String?
            let message: String?
            let userId: Int?
            let userJob: String?
            let userDetailJobs: [String]?
            let userWork: Int?
            let userNickname: String?
            let userProfileImg: String?
            let userProfileColor: String?
            let userIntro: String?
            let userSocialProvider: Int?
        }
    }
}

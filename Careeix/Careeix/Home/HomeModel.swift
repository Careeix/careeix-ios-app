//
//  OnboardingModel.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import Foundation

struct UserModel: Hashable, Codable {
    let userId: Int
    let userJob: String
    let userDetailJobs: [String]
    let userWork: Int
    let userNickname: String
    let userProfileImg: String
    let userProfileColor: String
    let userIntro: String?
    let userSocialProvider: Int
}

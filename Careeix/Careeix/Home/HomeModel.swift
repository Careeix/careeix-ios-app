//
//  OnboardingModel.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import Foundation
import Moya

struct CareerModel: Hashable, Codable {
    let profileImage: String
    let nickname: String
    let careerName: String
    let careerGrade: String
    let detailCareerNames: [String]
}
//{
//  "jwt": "string",
//  "message": "string",
//  "userDetailJobs": [
//    "string"
//  ],
//  "userId": 0,
//  "userIntro": "string",
//  "userJob": "string",
//  "userNickname": "string",
//  "userProfileColor": "string",
//  "userProfileImg": "string",
//  "userSocialProvider": 0,
//  "userWork": 0
//}






struct UserModel: Hashable, Codable {
    let userId: Int
    let userJob: String
    let userDetailJobs: [String]
    let userWork: Int
    let userNickname: String
    let userProfileImg: String?
    let userProfileColor: String
    let userIntro: String?
    let userSocialProvider: Int
}

extension CareerModel {
    static let minimalCareerProfileDummy: [CareerModel] = [
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "UI 디자이너", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["ui디자이너", "ux디자이너", "uiux디자이너"]
        )
    ]

    static let releventCareerProfilesDummy: [CareerModel] = [
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "서버개발자", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["자바", "스프링", "Java Spring"]
        ),
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "iOS 개발자", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["스위프트", "swift", "iOS"]
        ),
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "UI 디자이너", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["ui디자이너", "ux디자이너", "uiux디자이너"]
        ),
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "안드로이드 개발자 겸 서버 개발자", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["코틀린", "자바", "안드로이드"]
        ),
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "기획자", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["레벨", "기획"]
        ),
        CareerModel(
            profileImage: "person", nickname: "키키", careerName: "프로젝트 매니저", careerGrade: "주니어(1~4년차)",
            detailCareerNames: ["PM"]
        )
    ]
}

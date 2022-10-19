//
//  OnboardingModel.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import Foundation

struct CareerModel: Hashable {
    let profileImage: String
    let nickname: String
    let careerName: String
    let careerGrade: String
    let detailCareerName: [String]
}

struct RelevantCareerModel: Hashable {
    let careerName: String
    let careerGrade: String
    let detailCareerName: [String]
}

extension CareerModel {
    static let minimalCareerProfile: [CareerModel] = [CareerModel(profileImage: "person", nickname: "키키", careerName: "UI 디자이너", careerGrade: "주니어(1~4년차)", detailCareerName: ["#ui디자이너", "#ux디자이너", "#uiux디자이너"])]
}

extension RelevantCareerModel {
    static let releventCareerProfiles: [RelevantCareerModel] = [
        RelevantCareerModel(careerName: "서버개발자", careerGrade: "주니어(1~4년차)", detailCareerName: ["자바", "스프링", "Java Spring"]),
        RelevantCareerModel(careerName: "iOS 개발자", careerGrade: "주니어(1~4년차)", detailCareerName: ["스위프트", "swift", "iOS"]),
        RelevantCareerModel(careerName: "UI 디자이너", careerGrade: "주니어(1~4년차)", detailCareerName: ["ui디자이너", "ux디자이너", "uiux디자이너"]),
        RelevantCareerModel(careerName: "안드로이드 \n개발자", careerGrade: "주니어(1~4년차)", detailCareerName: ["코틀린", "자바", "안드로이드"]),
        RelevantCareerModel(careerName: "기획자", careerGrade: "주니어(1~4년차)", detailCareerName: ["레벨", "기획"]),
        RelevantCareerModel(careerName: "프로젝트 \n매니저", careerGrade: "주니어(1~4년차)", detailCareerName: ["PM"])
    ]
}

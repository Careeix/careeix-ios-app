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

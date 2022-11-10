//
//  File.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/11.
//

import Foundation

struct UpdateProfileModel: Codable {
    let userDetailJob: [String]
    let userIntro: String
    let userJob: String
    let userWork: Int
}

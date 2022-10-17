//
//  SignUpModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/17.
//

import Foundation
struct SignUpRequest {
    let nickName: String
    let job: String
    let annual: Int
    let detailJobs: [String]
}

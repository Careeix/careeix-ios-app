//
//  UserEntity.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/07.
//

import Foundation

extension Entity {
    enum SignUpUser {
        struct Request {
            let nickname: String
            let job: String
            let annual: Int
            let detailJobs: [String]
        }

    }
}

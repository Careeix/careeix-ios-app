//
//  ProjectDTO.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/06.
//

import Foundation

enum ProjectDTO {
    enum Update {
        struct Response: Decodable {
            let code: String?
            let message: String?
        }
    }
}


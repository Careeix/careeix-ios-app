//
//  ProjectModel.swift
//  Careeix
//
//  Created by mingmac on 2022/11/06.
//

import Foundation

struct ProjectModel: Hashable, Codable {
    let project_id: Int
    let title: String
    let start_date: String
    let end_date: String?
    let is_proceed: Int
    let classification: String
    let introduction: String
}

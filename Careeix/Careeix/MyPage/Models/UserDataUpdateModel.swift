//
//  UserDataUpdateModel.swift
//  Careeix
//
//  Created by mingmac on 2022/11/09.
//

import Foundation

struct UserDataUpdateModel: Codable {
    let code: String
    let timeStamp: String
    let message: String
    let data: [Responseresult]
}

struct Responseresult: Codable {
    let message: String
}

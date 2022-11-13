//
//  UserDataUpdateModel.swift
//  Careeix
//
//  Created by mingmac on 2022/11/09.
//

import Foundation

struct UpdateUserNicknameModel: Codable {
    let userNickname: String?
}

struct UpdateUserProfileImageModel: Codable {
    let userProfileImg: String?
}

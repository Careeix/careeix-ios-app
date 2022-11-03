//
//  UserAPI.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import Moya

struct UserAPI {
    static func kakaoLogin(accessToken: String) -> Observable<User.Response> {
        API<User.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .asObservable()
    }
    
    static func appleLogin(identifyToken: Data) -> Observable<User.Response> {
        Single.create { single in
            single(.success(User.Response.init(jwt: nil, message: "", userDetailJobs: nil, userId: nil, userIntro: nil, userJob: nil, userNickname: nil, userProfileColor: nil, userProfileImg: nil, userSocialProvider: nil, userWork: nil)))
            return Disposables.create()
        }.asObservable()
    }
    
    static func kakaoSignUp(with info: User.Request) -> Observable<User.Response> {
        API<User.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(info)).requestRX()
            .asObservable()
    }
    
    
    
}

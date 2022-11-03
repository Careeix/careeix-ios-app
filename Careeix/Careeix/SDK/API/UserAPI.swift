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
            single(.failure(NSError(domain: "aa", code: 0)))
//            single(.success(User.Response(jwt: nil, message: "", userId: -999, userJob: "", userDetailJobs: [], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "'", userIntro: "", userSocialProvider: 0)))
            return Disposables.create()
        }.asObservable()
    }
    
    static func kakaoSignUp(with info: User.Request) -> Observable<User.Response> {
        API<User.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(info)).requestRX()
            .asObservable()
    }
    
    
    
}

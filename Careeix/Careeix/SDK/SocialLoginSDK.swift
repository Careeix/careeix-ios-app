//
//  SocialLoginSDK.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/17.
//

import Foundation

import RxSwift

// TODO: 애플로그인 구현
struct LoginAPI {
    struct Response {
        let jwt: String
    }
}

struct KakaoUser {
    
}

class SocialLoginSDK {
    private let disposeBag = DisposeBag()
    private static let socialLoginService = SocialLoginService()
    typealias needMoreInfo = Bool
    enum SocialLoginType {
        case kakao
//        case apple
    }
    
    public static func setUrl(with url: URL) {
        socialLoginService.setKakaoUrl(with: url)
    }
    
    public static func initSDK(type: SocialLoginType) {
        switch type {
        case .kakao:
            // TODO: Key 프로젝트에 따로 넣기
            socialLoginService.initKakaoSDK()
        }
    }
    
    public static func socialLogin(type: SocialLoginType) -> Observable<Bool> {
        switch type {
        case .kakao:
            return socialLoginService.kakaoLogin()
        }
    }
    
    public static func socialLogout(type: SocialLoginType) -> Bool {
        switch type {
        case .kakao:
            return socialLoginService.kakaoLogout()
        }
    }
    
    public static func readUserInfo(type: SocialLoginType) {
        switch type {
        case .kakao:
            return socialLoginService.readKakaoUserInfo()
        }
    }
}

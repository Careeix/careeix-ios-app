//
//  SocialLoginSDK.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/17.
//

import Foundation

import RxSwift

typealias needMoreInfo = Bool
struct LoginAPI {
    struct Response: Decodable {
        let jwt: String?
        let message: String
    }
}

class SocialLoginSDK {
    private let disposeBag = DisposeBag()
    private static let socialLoginService = SocialLoginService()
    
    enum SocialLoginType {
        case kakao
        case apple
    }
    
    public static func setUrl(with url: URL) -> Bool {
        socialLoginService.setKakaoUrl( with: url)
    }
    
    public static func initSDK(type: SocialLoginType) {
        switch type {
        case .kakao:
            // TODO: Key 프로젝트에 따로 넣기
            socialLoginService.initKakaoSDK()
        default:
            break
        }
    
    }
    
    public static func socialLogin(type: SocialLoginType) -> Observable<LoginAPI.Response> {
        switch type {
        case .kakao:
            return socialLoginService.kakaoLogin()
        case .apple:
            return socialLoginService.appleLogin()
        }
    }
    
    public static func socialLogout(type: SocialLoginType) -> Observable<Bool> {
        switch type {
        case .kakao:
            return socialLoginService.kakaoLogout()
        case .apple:
            return .just(true)
        }
    }
}

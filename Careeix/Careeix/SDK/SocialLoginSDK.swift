//
//  SocialLoginSDK.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/17.
//

import Foundation

import RxSwift

typealias needMoreInfo = Bool

class SocialLoginSDK {
    private let disposeBag = DisposeBag()
    private static let socialLoginService = SocialLoginService()
    
    enum SocialLoginType: Codable {
        case kakao
        case apple
    }
    
    public static func setUrl(with url: URL) -> Bool {
        socialLoginService.setKakaoUrl( with: url)
    }
    
    public static func initSDK(type: SocialLoginType) {
        switch type {
        case .kakao:
            socialLoginService.initKakaoSDK()
        default:
            break
        }
    
    }
    
    public static func socialLogin(type: SocialLoginType) -> Observable<DTO.User.Response> {
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
    
    public static func socialSignUp(with info: DTO.User.Request) -> Observable<DTO.User.Response> {
        return socialLoginService.socialSignUp(with: info)
    }
}

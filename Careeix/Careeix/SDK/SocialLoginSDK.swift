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
    struct Response: Decodable {
        let jwt: String?
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
    }
    
    public static func setUrl(with url: URL) -> Bool {
        socialLoginService.setKakaoUrl( with: url)
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
    
    public static func socialLogout(type: SocialLoginType) -> Observable<Bool> {
        switch type {
        // TODO: - 로그인 형식을 Realm에 저장해야하는가 고민
        case .kakao:
            return socialLoginService.kakaoLogout()
        }
    }
}

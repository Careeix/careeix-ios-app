//
//  SocialLoginService.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/18.
//

import Foundation

import RxSwift
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import CareeixKey
import Moya

protocol KakaoLoginService {
    func setKakaoUrl(with url: URL) -> Bool
    func initKakaoSDK()
    func kakaoLogin()
    func kakaoLogout() -> Bool
    func readKakaoUserInfo()
}

final class SocialLoginService {
    let disposeBag = DisposeBag()
    
    enum SocialLoginError: Error {
        case kakaoTalkNotFound
    }
}

extension SocialLoginService {
    
    func setKakaoUrl(with url: URL) -> Bool {
        AuthApi.isKakaoTalkLoginUrl(url)
        ? AuthController.handleOpenUrl(url: url)
        : false
    }
    
    func initKakaoSDK() {
        KakaoSDK.initSDK(appKey: CareeixKey.SdkKey.kakao)
    }
    
    func readAccessToken() -> Observable<String> {
        return UserApi.shared.rx.loginWithKakaoAccount()
            .map { $0.accessToken }
            .catch { _ in .just("") }
            .do { UserDefaultManager.shared.kakaoAccessToken = $0 }
            .debug("카카오 로그인 SDK")
    }
    
    func callLoginApi(token: String) -> Single<LoginAPI.Response> {
        // test
        let a = Single.create { single in
            single(.success(LoginAPI.Response.init(jwt: nil)))
            return Disposables.create()
        }.debug("AAAAAA")
        
//        // 현재 api call (이상함. access토큰을 body로 보내야함)
//        let b = API<LoginAPI.Response>(path: "/api/v1/users/check-login/\(token)", method: .post, parameters: [:], task: .requestPlain).requestRX().debug("BBBBBB")
//        
//        // 정상적인 api call
//        let c = API<LoginAPI.Response>(path: "/api/v1/users/check-login)", method: .post, parameters: ["X-ACCESS-TOKEN": token], task: .requestParameters(encoding: JSONEncoding.default)).requestRX().debug("CCCCCC")
        return a
    }
    
    func kakaoLogin() -> Observable<Bool> {
        return readAccessToken()
            .filter { $0 != "" }
            .flatMap(self.callLoginApi)
            .do { UserDefaultManager.shared.jwtToken = $0.jwt ?? "" }
            .map { $0.jwt == nil }
    }
    
    func kakaoLogout() -> Observable<Bool> {
        UserApi.shared.logout { error in
            print(error ?? "error is nil")
        }
        return .just(true)
    }
}

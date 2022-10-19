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
    }
    
    func callLoginApi(token: String) -> Single<LoginAPI.Response> {
        return Single.create { single in
            single(.success(.init(jwt: "asd")))
            return Disposables.create()
        }
    }
    
    func kakaoLogin() -> Observable<Bool> {
        return readAccessToken()
            .flatMap { self.callLoginApi(token: $0) }
            .map { return $0.jwt == "" }
    }
    
    func kakaoLogout() -> Bool {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
        return true
    }
    
    func readKakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe (onSuccess:{ user in
                print("me() success.")
                _ = user
                print(user)
            }, onFailure: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

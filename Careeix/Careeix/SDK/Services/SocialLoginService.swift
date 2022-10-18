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
    func kakaoLogin() -> Single<LoginAPI.Response>
    func kakaoLogout()
    func readKakaoUserInfo()
}

final class SocialLoginService {
    let disposeBag = DisposeBag()
    
    enum SocialLoginError: Error {
        case kakaoTalkNotFound
    }
}

extension SocialLoginService: KakaoLoginService {

    func setKakaoUrl(with url: URL) -> Bool {
        AuthApi.isKakaoTalkLoginUrl(url)
       ? AuthController.handleOpenUrl(url: url)
       : false
    }
    
    func initKakaoSDK() {
        KakaoSDK.initSDK(appKey: "8b4d1b1dd2629909afbd1e266ec9a7de")
    }
    
    func kakaoLogin() -> Single<LoginAPI.Response> {
        return Single<LoginAPI.Response>.create { single in
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe  { oauthToken in
                        _ = oauthToken
                        // TODO: - 서버 통신
                        return single(.success(.init(isSuccess: true)))
                    } onError: { error in
                        return single(.failure(error))
                    }.disposed(by: DisposeBag())
            } else {
                // TODO: - Error를 옵저버블로 ?
                return single(.failure(SocialLoginError.kakaoTalkNotFound)) as! Disposable
            }
            return Disposables.create()
        }
    }
    
    func kakaoLogout() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func readKakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe (onSuccess:{ user in
                print("me() success.")
                
                //do something
                _ = user
            }, onFailure: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

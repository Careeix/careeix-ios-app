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
    func kakaoLogin() -> Bool
    func kakaoLogout() -> Bool
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
        KakaoSDK.initSDK(appKey: CareeixKey.SdkKey.kakao)
    }
    
    func kakaoLogin() -> Bool {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                print("error")
                UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                    print("get oauthToken: ", oauthToken)
                }
//                    .subscribe  { oauthToken in
//                        _ = oauthToken
//                        // TODO: - 서버 통신
//                        
//                        
//                    } onError: { error in
//                        print(error)
//                    }.disposed(by: DisposeBag())
                return true
            } else {
                UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoAccount() success.")
                            _ = oauthToken
                            
                        }
                    }
                return false
            }
        
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

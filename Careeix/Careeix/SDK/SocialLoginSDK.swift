//
//  SocialLoginSDK.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/17.
//

import Foundation

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift
// TODO: 애플로그인 구현
class SocialLoginSDK {
    private let disposeBag = DisposeBag()
    
    enum LoginType {
        case kakao
        case apple
    }
    
    public static func setUrl(with url: URL) {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
    
    public static func initSDK(type: LoginType) {
        switch type {
        case .kakao:
            // TODO: Key 프로젝트에 따로 넣기
            KakaoSDK.initSDK(appKey: "8b4d1b1dd2629909afbd1e266ec9a7de")
            
        case .apple: break
        }
    }
    
    public static func socialLogin(type: LoginType) {
        switch type {
        case .kakao: break
        case .apple: break
        }
    }
    
}

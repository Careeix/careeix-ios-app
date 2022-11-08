//
//  SocialLoginService.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/18.
//

import Foundation

import RxSwift
import RxRelay
import RxCocoa
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import CareeixKey
import Moya
import AuthenticationServices

protocol KakaoLoginService {
    func setKakaoUrl(with url: URL) -> Bool
    func initKakaoSDK()
    func kakaoLogin()
    func kakaoLogout() -> Bool
    func readKakaoUserInfo()
}

final class SocialLoginService: NSObject {
    let disposeBag = DisposeBag()
    let userRepository = UserRepository()
    
    var appleIdentityTokenSubject = PublishSubject<Data>()
    
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
            .take(1)
            .debug("카카오 로그인 SDK")
            .map { $0.accessToken }
            .do { UserDefaultManager.kakaoAccessToken = $0 }
            .catch { _ in .just("토큰 에러") }
            
    }

    func kakaoLogin() -> Observable<User> {
        return readAccessToken()
            .filter { $0 != "토큰 에러" }
            .flatMap(userRepository.kakaoLogin)

    }

    func kakaoLogout() -> Observable<Bool> {
        UserApi.shared.logout { error in
            print(error ?? "error is nil")
        }
        return .just(true)
    }
    
    func appleLogin() -> Observable<User> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        return appleIdentityTokenSubject
            .flatMap(userRepository.appleLogin)
            .catch { _ in .just(.init(jwt: "", message: "애플로그인이 취소되었습니다")) }
    }
    
    func socialSignUp(with info: Entity.SignUpUser.Request) -> Observable<User> {
        return userRepository.kakaoSignUp(with: info)
    }
}

extension SocialLoginService: ASAuthorizationControllerDelegate,   ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                // 계정 정보 가져오기
            guard let identityToken = appleIDCredential.identityToken else { return }
            guard let authorizationCode = appleIDCredential.authorizationCode else { return }
            let accessToken = String(data: identityToken, encoding: .ascii)!
            let authCode = String(data: authorizationCode, encoding: .ascii)!
            print("accessToken:\n", accessToken)
            print("authorizationCode:\n", authCode)
            appleIdentityTokenSubject.onNext(identityToken)
            appleIdentityTokenSubject.onCompleted()
            default:
                break
            }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleIdentityTokenSubject.onError(error)
        appleIdentityTokenSubject.onCompleted()
        appleIdentityTokenSubject = PublishSubject<Data>()
    }
}

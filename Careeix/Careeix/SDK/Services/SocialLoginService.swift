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
            .catch { _ in .just("토큰 에러") }
            .do { UserDefaultManager.shared.kakaoAccessToken = $0 }
    }
    
    func callKakaoLoginApi(accessToken: String) -> Observable<LoginAPI.Response> {
        let c = API<LoginAPI.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .asObservable()
        
        return c
    }

    func kakaoLogin() -> Observable<LoginAPI.Response> {
        return readAccessToken()
            .debug("🤪🤪🤪🤪🤪")
            .filter { $0 != "토큰 에러" }
            .flatMap(callKakaoLoginApi)
    }
    
    func kakaoLogout() -> Observable<Bool> {
        UserApi.shared.logout { error in
            print(error ?? "error is nil")
        }
        return .just(true)
    }

    func callAppleLoginApi(identityToken: Data) -> Single<LoginAPI.Response> {
        // test
        let a = Single.create { single in
            single(.success(LoginAPI.Response.init(jwt: nil, message: "추가정보 입력!")))
            return Disposables.create()
        }.debug("😡AppleApi!😡")
        return a
    }
    
    func appleLogin() -> Observable<LoginAPI.Response> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        return appleIdentityTokenSubject
            .flatMap(callAppleLoginApi)
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
            appleIdentityTokenSubject.onNext(identityToken)
            appleIdentityTokenSubject.onCompleted()
            default:
                break
            }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플로그인 실패 !: ", error)
        appleIdentityTokenSubject.onCompleted()
        appleIdentityTokenSubject = PublishSubject<Data>()
    }
}

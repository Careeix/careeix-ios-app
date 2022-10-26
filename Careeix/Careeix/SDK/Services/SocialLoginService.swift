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
            .debug("카카오 로그인 SDK")
            .map { $0.accessToken }
            .catch { _ in .just("") }
            .do { UserDefaultManager.shared.kakaoAccessToken = $0 }
            
    }
    
    func callKakaoLoginApi(accessToken: String) -> Single<LoginAPI.Response> {
        // test
        let a = Single.create { single in
            single(.success(LoginAPI.Response.init(jwt: nil)))
            return Disposables.create()
        }.debug("AAAAAA")
        
//        // 현재 api call (이상함. access토큰을 body로 보내야함)
//        let b = API<LoginAPI.Response>(path: "/api/v1/users/check-login/\(token)", method: .post, parameters: [:], task: .requestPlain).requestRX().debug("BBBBBB")
        
//         정상적인 api call
        let c = API<LoginAPI.Response>(path: "/api/v1/users/check-login", method: .post, parameters: ["X-ACCESS-TOKEN": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX().debug("CCCCCC")
        return a
    }

    func kakaoLogin() -> Observable<Bool> {
        return readAccessToken()
            .filter { $0 != "" }
            .flatMap(callKakaoLoginApi)
            .do { UserDefaultManager.shared.jwtToken = $0.jwt ?? "" }
            .map { $0.jwt == nil }
    }
    
    func kakaoLogout() -> Observable<Bool> {
        UserApi.shared.logout { error in
            print(error ?? "error is nil")
        }
        return .just(true)
    }

    func callAppleLoginApi(identityToken: Data) -> Single<LoginAPI.Response> {
        print(identityToken)
        // test
        let a = Single.create { single in
            single(.success(LoginAPI.Response.init(jwt: nil)))
            return Disposables.create()
        }.debug("😡AppleApi!😡")
        return a
    }
    
    func appleLogin() -> Observable<Bool> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
                
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        return appleIdentityTokenSubject
            .debug("😤😤😤need More Info😤😤😤")
            .take(1)
            .flatMap(callAppleLoginApi)
            .map { $0.jwt == nil }
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
            guard let identityToken = appleIDCredential.identityToken else {
                print("identityToken을 애플 서버에서 받아오는데에 실패했습니다,")
                return
            }
            appleIdentityTokenSubject.onNext(identityToken)
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

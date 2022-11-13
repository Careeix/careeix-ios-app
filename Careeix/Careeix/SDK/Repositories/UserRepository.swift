//
//  UserAPI.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import Moya

struct UserRepository {
    func kakaoLogin(accessToken: String) -> Observable<User> {
        API<UserDTO.KakaoLogin.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .map(convertKakaoUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }.debug("🐯🐯🐯KAKAOLOGIN🐯🐯🐯")
    }
    
    func appleLogin(identityToken: String) -> Observable<User> {
        API<UserDTO.AppleLogin.Response>(path: "users/check-login-apple", method: .post, parameters: ["identityToken": identityToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .map(convertAppleUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }.debug("🐯🐯🐯APPLELOGIN🐯🐯🐯")
    }
    
    func kakaoSignUp(with info: Entity.SignUpUser.Request) -> Observable<User> {
        return API<UserDTO.KakaoLogin.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(convertKakaoSignUpRequestDTO(info))).requestRX()
            .map(convertKakaoUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }.debug("🐯🐯🐯KAKAOSignUp🐯🐯🐯")
    }
    
    func appleSignUp(with info: Entity.SignUpUser.Request) -> Observable<User> {
        return API<UserDTO.AppleLogin.Response>(path: "users/apple-login", method: .post, parameters: [:], task: .requestJSONEncodable(convertAppleSignUpRequestDTO(info))).requestRX()
            .map(convertAppleUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }.debug("🐯🐯🐯APPLESIGNUP🐯🐯🐯")
    }
    
    func updateProfile(with profile: UpdateProfileModel) -> Observable<ErrorResponse> {
        API<ErrorResponse>(path: "users/update-info", method: .post, parameters: [:], task: .requestJSONEncodable(profile))
            .requestRX()
            .map { _ in ErrorResponse(code: "200", message: "저장되었습니다.") }
            .catch { error in
                if let error = error as? ErrorResponse {
                    return .just(.init(code: error.code, message: error.message))
                } else {
                    return .just(.init(code: "500", message: "네트워크 환경을 확인해주세요."))
                }
            }.debug("🦊🦊🦊프로필 POST🦊🦊")
    }
    

    
    func errorUser(message: String = "네트워크 환경을 확인해주세요.") -> Observable<User>{
        .just(.init(jwt: "", message: message))
    }
    
    // KAKAO
    func convertKakaoSignUpRequestDTO(_ entity: Entity.SignUpUser.Request) -> UserDTO.KakaoLogin.Request {
        .init(accessToken: UserDefaultManager.kakaoAccessToken, job: entity.job, nickname: entity.nickname, userDetailJob: entity.detailJobs, userWork: entity.annual)
    }
    
    func convertAppleSignUpRequestDTO(_ entity: Entity.SignUpUser.Request) -> UserDTO.AppleLogin.Request {
        .init(identityToken: UserDefaultManager.appleIdentityToken, job: entity.job, nickname: entity.nickname, userDetailJob: entity.detailJobs, userWork: entity.annual)
    }
    
    
    func convertKakaoUserResponseDTO(_ dto: UserDTO.KakaoLogin.Response) -> User {
        .init(jwt: dto.jwt ?? "1" ,
              message: dto.message ?? "",
              userId: dto.userId ?? 0,
              userJob: dto.userJob ?? "",
              userDetailJobs: dto.userDetailJobs ?? [],
              userWork: dto.userWork ?? 0,
              userNickname: dto.userNickname ?? "",
              userProfileImg: dto.userProfileImg ?? "",
              userProfileColor: dto.userProfileColor ?? "",
              userIntro: dto.userIntro ?? "",
              userSocialProvider: dto.userSocialProvider ?? 0)
    }
    
    func convertAppleUserResponseDTO(_ dto: UserDTO.AppleLogin.Response) -> User {
        .init(jwt: dto.jwt ?? "1" ,
              message: dto.message ?? "",
              userId: dto.userId ?? 0,
              userJob: dto.userJob ?? "",
              userDetailJobs: dto.userDetailJobs ?? [],
              userWork: dto.userWork ?? 0,
              userNickname: dto.userNickname ?? "",
              userProfileImg: dto.userProfileImg ?? "",
              userProfileColor: dto.userProfileColor ?? "",
              userIntro: dto.userIntro ?? "",
              userSocialProvider: dto.userSocialProvider ?? 0)
    }
}

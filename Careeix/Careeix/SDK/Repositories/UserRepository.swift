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
    func kakaoLogin(accessToken: String) -> Observable<Entity.LoginUser.Response> {
        API<DTO.User.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .map(convertLoginResponseDTO)
    }
    
    func appleLogin(identifyToken: Data) -> Observable<Entity.LoginUser.Response> {
        Single.create { single in
            single(.failure(NSError(domain: "aa", code: 0)))
            return Disposables.create()
        }.asObservable()
    }
    
    func kakaoSignUp(with info: Entity.SignUpUser.Request) -> Observable<Entity.SignUpUser.Response> {
        print(UserDefaultManager.kakaoAccessToken)
        return API<DTO.User.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(convertSignUpRequestDTO(info))).requestRX()
            .map(converSignUpResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    UserDefaultManager.user.message = error.message
                    UserDefaultManager.user.jwt = ""
                }
                return .just(.init(jwt: "", message: "", userId: 0, userJob: "", userDetailJobs: [], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0))
            }
    }
    // KAKAO
    // TODO: 카카오와 애플 어떻게 할껀지 ..

    func convertSignUpRequestDTO(_ entity: Entity.SignUpUser.Request) -> DTO.User.Request {
        .init(token: UserDefaultManager.kakaoAccessToken, job: entity.job, nickname: entity.nickname, userDetailJob: entity.detailJobs, userWork: entity.annual)
    }
    
    func convertLoginResponseDTO(_ dto: DTO.User.Response) -> Entity.LoginUser.Response {
        .init(jwt: dto.jwt ?? "" ,
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
    
    func converSignUpResponseDTO(_ dto: DTO.User.Response) -> Entity.SignUpUser.Response {
        .init(jwt: dto.jwt ?? "" ,
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

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
        API<DTO.User.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .map(convertUserResponseDTO)
    }
    
    func appleLogin(identifyToken: Data) -> Observable<User> {
        Single.create { single in
            single(.failure(NSError(domain: "aa", code: 0)))
            return Disposables.create()
        }.asObservable()
    }
    
    func kakaoSignUp(with info: Entity.SignUpUser.Request) -> Observable<User> {
        return API<DTO.User.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(convertSignUpRequestDTO(info))).requestRX()
            .map(convertUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return .just(.init(jwt: "", message: error.message, userId: 0, userJob: "", userDetailJobs: [], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0))
                } else {
                    return .just(.init(jwt: "", message: "네트워크 환경을 확인해주세요.", userId: 0, userJob: "", userDetailJobs: [], userWork: 0, userNickname: "", userProfileImg: "'", userProfileColor: "'", userIntro: "'", userSocialProvider: 0))
                }

            }
    }
    // KAKAO
    // TODO: 카카오와 애플 어떻게 할껀지 .. (카카오는 String, 애플은 Data)
    func convertSignUpRequestDTO(_ entity: Entity.SignUpUser.Request) -> DTO.User.Request {
        .init(accessToken: UserDefaultManager.kakaoAccessToken, job: entity.job, nickname: entity.nickname, userDetailJob: entity.detailJobs, userWork: entity.annual)
    }
    
    func convertUserResponseDTO(_ dto: DTO.User.Response) -> User {
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

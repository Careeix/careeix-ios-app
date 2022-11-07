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
        API<UserDTO.Response>(path: "users/check-login", method: .post, parameters: ["accessToken": accessToken], task: .requestParameters(encoding: JSONEncoding.default)).requestRX()
            .map(convertUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }
    }
    
    func appleLogin(identifyToken: Data) -> Observable<User> {
        Observable.create { observer in
            observer.onError(ErrorResponse(code: "Asd", message: "실패"))
            return Disposables.create()
        }.catch { error in
            if let error = error as? ErrorResponse {
                return errorUser(message: error.message)
            } else {
                return errorUser()
            }
        }
    }
    
    func kakaoSignUp(with info: Entity.SignUpUser.Request) -> Observable<User> {
        return API<UserDTO.Response>(path: "users/kakao-login", method: .post, parameters: [:], task: .requestJSONEncodable(convertSignUpRequestDTO(info))).requestRX()
            .map(convertUserResponseDTO)
            .catch { error in
                if let error = error as? ErrorResponse {
                    return errorUser(message: error.message)
                } else {
                    return errorUser()
                }
            }
    }
    func errorUser(message: String = "네트워크 환경을 확인해주세요.") -> Observable<User>{
        .just(.init(jwt: "", message: message))
    }
    
    // KAKAO
    // TODO: 카카오와 애플 어떻게 할껀지 .. (카카오는 String, 애플은 Data)
    func convertSignUpRequestDTO(_ entity: Entity.SignUpUser.Request) -> UserDTO.Request {
        .init(accessToken: UserDefaultManager.kakaoAccessToken, job: entity.job, nickname: entity.nickname, userDetailJob: entity.detailJobs, userWork: entity.annual)
    }
    
    func convertUserResponseDTO(_ dto: UserDTO.Response) -> User {
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

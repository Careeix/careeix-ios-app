//
//  OnboardViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

struct OnboardViewModel {
    typealias contentOffsetX = CGFloat
    typealias screenWidth = CGFloat
    
    // MARK: - Input
    let endDraggingRelay = BehaviorRelay<(contentOffsetX, screenWidth)>(value: (0, 1))
    let socialLoginTrigger = PublishRelay<SocialLoginSDK.SocialLoginType>()
    
    // MARK: - Output
    let logoImageNameDriver: Driver<String>
    let kakaoLoginButtonImageNameDriver: Driver<String>
    let appleLoginButtonImageNameDriver: Driver<String>
    let onboardImageNamesDriver: Driver<[String]>
    let currentPageDriver: Driver<Int>
    let showHomeViewDriver: Driver<Void>
    let showSignUpViewDriver: Driver<Void>
    
    init() {
        logoImageNameDriver = .just("logo")
        kakaoLoginButtonImageNameDriver = .just("kakaoLogin")
        appleLoginButtonImageNameDriver = .just("appleLogin")
        onboardImageNamesDriver = .just(["onboard_0", "onboard_1", "onboard_2"])
        
        currentPageDriver = endDraggingRelay
            .map { Int($0 / $1) }
            .asDriver(onErrorJustReturn: 0)
        
        let loginResponseObservable = socialLoginTrigger
            .do {UserDefaultManager.loginType = $0 }
            .flatMap(SocialLoginSDK.socialLogin)
            .catch { error in
                print(error)
                return .just(.init(jwt: nil, message: "로그인 실패", userId: -999, userJob: "", userDetailJobs: [], userWork: 0, userNickname: "", userProfileImg: "'", userProfileColor: "'", userIntro: nil, userSocialProvider: 0))
            }
        
        // TODO: 모델 하나로 통일 (jwt삭제)
        let needMoreInfoObservableShare = loginResponseObservable
            .filter { $0.message != "로그인 실패" }
            .do { UserDefaultManager.user = convertUserDTO(user: $0) }
            .do { UserDefaultManager.jwtToken = $0.jwt ?? "" }
            .map { $0.jwt == nil }
            .do { _ in print("jwt Token: ", UserDefaultManager.jwtToken) }
            .share()
            
        showHomeViewDriver = needMoreInfoObservableShare
            .filter { !$0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        showSignUpViewDriver = needMoreInfoObservableShare
            .filter { $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        func convertUserDTO(user: DTO.User.Response) -> User {
            return .init(jwt: user.jwt ?? "", message: user.message, userId: user.userId, userJob: user.userJob, userDetailJobs: user.userDetailJobs, userWork: user.userWork, userNickname: user.userNickname, userProfileImg: user.userProfileImg, userProfileColor: user.userProfileColor, userIntro: user.userIntro, userSocialProvider: user.userSocialProvider)
        }
    }
}

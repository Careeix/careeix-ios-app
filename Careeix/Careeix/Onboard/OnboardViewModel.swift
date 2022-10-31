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
import RxKakaoSDKAuth
struct OnboardViewModel {
    typealias contentOffsetX = CGFloat
    typealias screenWidth = CGFloat
    
    // MARK: - Input
    let endDraggingRelay = BehaviorRelay<(contentOffsetX, screenWidth)>(value: (0, 1))
    let kakaoLoginTrigger = PublishRelay<Void>()
    let appleLoginTrigger = PublishRelay<Void>()
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
            .debug("소셜 로그인 버튼 클릭 !")
            .flatMap(SocialLoginSDK.socialLogin) // Bool...
            .catch { error in
                print(error)
                return .just(.init(jwt: nil, message: "로그인 실패"))
            }
        let needMoreInfoObservableShare = loginResponseObservable
            .filter { $0.message != "로그인 실패" }
            .do { UserDefaultManager.shared.jwtToken = $0.jwt ?? "" }
            .map { $0.jwt == nil }
            .do { _ in print("jwt Token: ", UserDefaultManager.shared.jwtToken) }
            .share()
            
        showHomeViewDriver = needMoreInfoObservableShare
            .filter { !$0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        showSignUpViewDriver = needMoreInfoObservableShare
            .filter { $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
    }
}

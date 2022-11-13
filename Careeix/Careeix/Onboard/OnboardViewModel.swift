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
    let showAlertViewDriver: Driver<Void>
    init() {
        logoImageNameDriver = .just("logo")
        kakaoLoginButtonImageNameDriver = .just("kakaoLogin")
        appleLoginButtonImageNameDriver = .just("appleLogin")
        onboardImageNamesDriver = .just(["onboard_0", "onboard_1", "onboard_2"])
        
        currentPageDriver = endDraggingRelay
            .map { Int($0 / $1) }
            .asDriver(onErrorJustReturn: 0)
        
        let loginResponseObservable = socialLoginTrigger
            .do { UserDefaultManager.loginType = $0 }
            .flatMap(SocialLoginSDK.socialLogin)
            .do { UserDefaultManager.user = $0 }
            .share()
        
        let needMoreInfoObservableShare = loginResponseObservable
            .map { $0.jwt == "1" }
            .do { _ in print("jwt Token: ", UserDefaultManager.user.jwt) }
            .share()
            
        showHomeViewDriver = needMoreInfoObservableShare
            .filter { !$0 && UserDefaultManager.user.jwt != "" }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        showAlertViewDriver = needMoreInfoObservableShare
            .filter { !$0 && UserDefaultManager.user.jwt == "" }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        showSignUpViewDriver = needMoreInfoObservableShare
            .filter { $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())

    }
}

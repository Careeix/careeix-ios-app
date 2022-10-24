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
    
    // MARK: - Output
    let logoImageNameDriver: Driver<String>
    let kakaoLoginButtonImageNameDriver: Driver<String>
    let appleLoginButtonImageNameDriver: Driver<String>
    let onboardImageNamesDriver: Driver<[String]>
    let currentPageDriver: Driver<Int>
    let showHomeViewDriver: Driver<Void>
    let showSignUpViewDriver: Driver<Void>
    init() {
        logoImageNameDriver = Observable.just("logo").asDriver(onErrorJustReturn: "")
        kakaoLoginButtonImageNameDriver = Observable.just("kakaoLogin").asDriver(onErrorJustReturn: "")
        appleLoginButtonImageNameDriver = Observable.just("appleLogin").asDriver(onErrorJustReturn: "")
        onboardImageNamesDriver = Observable.just(["onboard_0", "onboard_1", "onboard_2"]).asDriver(onErrorJustReturn: [])
        
        currentPageDriver = endDraggingRelay
            .map { Int($0 / $1) }
            .asDriver(onErrorJustReturn: 0)
        
        let needMoreInfoDriver = kakaoLoginTrigger
            .debug("카카오 로그인 버튼 클릭 !")
            .flatMap { SocialLoginSDK.socialLogin(type: .kakao) }
            .do { print("🌂🌂🌂result: 🌂🌂🌂", $0)}
            .asDriver(onErrorJustReturn: true)
        
        showHomeViewDriver = needMoreInfoDriver
            .filter { !$0 }
            .map { _ in () }
        
        showSignUpViewDriver = needMoreInfoDriver
            .filter { $0 }
            .map { _ in () }
    }
}

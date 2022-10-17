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
    
    // MARK: - Output
    let logoImageNameDriver: Driver<String>
    let kakaoLoginButtonImageNameDriver: Driver<String>
    let appleLoginButtonImageNameDriver: Driver<String>
    let onboardImageNamesDriver: Driver<[String]>
    let currentPageDriver: Driver<Int>
    
    init() {
        logoImageNameDriver = Observable.just("logo").asDriver(onErrorJustReturn: "")
        
        kakaoLoginButtonImageNameDriver = Observable.just("kakaoLogin").asDriver(onErrorJustReturn: "")
        
        appleLoginButtonImageNameDriver = Observable.just("appleLogin").asDriver(onErrorJustReturn: "")
        
        onboardImageNamesDriver = Observable.just(["onboard_0", "onboard_1", "onboard_2"]).asDriver(onErrorJustReturn: [])
        
        currentPageDriver = endDraggingRelay
            .map { Int($0 / $1) }
            .asDriver(onErrorJustReturn: 0)

    }
}

//
//  SignUpViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/16.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
class SignUpViewModel {
    // TODO: 주석 삭제
//    typealias nickName = String
//    typealias job = String
//    typealias annualIndex = IndexPath
//    typealias detailJobs = [String]
    
    // MARK: SubViewModels
    let nickNameInputViewModel: SimpleInputViewModel
    let jobInputViewModel: SimpleInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobsInputViewModel: MultiInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    // MARK: - Input
    // TODO: 주석 삭제
//    let combinedInputValuesObservable: Observable<(nickName, job, annualIndex, detailJobs)>
    let createUserTrigger =  PublishRelay<Void>()
    
    // MARK: - Output
    let completeButtonEnableDriver: Driver<Void>
    let completeButtonDisableDriver: Driver<Void>
    let showTabbarCotrollerDriver: Driver<Void>
    
    
    // MARK: - Initializer
    init(nickNameInputViewModel: SimpleInputViewModel, jobInputViewModel: SimpleInputViewModel, annualInputViewModel: RadioInputViewModel, detailJobsInputViewModel: MultiInputViewModel, completeButtonViewModel: CompleteButtonViewModel) {
        
        self.nickNameInputViewModel = nickNameInputViewModel
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobsInputViewModel = detailJobsInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
        
        let combinedInputValuesObservable =  Observable.combineLatest(
            nickNameInputViewModel.inputStringRelay,
            jobInputViewModel.inputStringRelay,
            annualInputViewModel.selectedIndexRelay,
            detailJobsInputViewModel.inputValuesObservable
        ) {
            ($0, $1, $2, $3)
        }
        
//        createUserTrigger

        
        showTabbarCotrollerDriver = createUserTrigger
            .withLatestFrom(combinedInputValuesObservable) { $1 }
            .do { print("post: ", $0) }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        let buttonStateDriver = combinedInputValuesObservable
            .map { nickName, job, annualIndex, detailJobs in
                nickName != "" && job != "" && detailJobs.count != 0
            }.distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        completeButtonEnableDriver = buttonStateDriver.filter { $0 }.map { _ in () }
        completeButtonDisableDriver = buttonStateDriver.filter { !$0 }.map { _ in () }
    }

}

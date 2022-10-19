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
    // MARK: Types
    typealias nickName = String
    typealias job = String
    typealias annualIndex = IndexPath
    typealias detailJobs = [String]
    
    // MARK: SubViewModels
    let nickNameInputViewModel: SimpleInputViewModel
    let jobInputViewModel: SimpleInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobsInputViewModel: MultiInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    // MARK: - Input
    let combinedInputValuesObservable: Observable<(nickName, job, annualIndex, detailJobs)>
    let createUserTrigger =  PublishRelay<Void>()
    
    // MARK: - Output
    let completeButtonEnableDriver: Driver<Void>
    let completeButtonDisableDriver: Driver<Void>
    // MARK: - Initializer
    init(nickNameInputViewModel: SimpleInputViewModel, jobInputViewModel: SimpleInputViewModel, annualInputViewModel: RadioInputViewModel, detailJobsInputViewModel: MultiInputViewModel, completeButtonViewModel: CompleteButtonViewModel) {
        
        self.nickNameInputViewModel = nickNameInputViewModel
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobsInputViewModel = detailJobsInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
        
        combinedInputValuesObservable =  Observable.combineLatest(
            nickNameInputViewModel.inputStringRelay,
            jobInputViewModel.inputStringRelay,
            annualInputViewModel.selectedIndexRelay,
            detailJobsInputViewModel.inputValuesObservable
        ) {
            ($0, $1, $2, $3)
        }
        
        createUserTrigger
            .withLatestFrom(combinedInputValuesObservable) { $1 }
            .subscribe {
                print("post: ", $0)
            }
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { nickName, job, annualIndex, detailJobs in
                nickName != "" && job != "" && detailJobs.filter { $0 == "" }.count != detailJobs.count
            }.asDriver(onErrorJustReturn: false)
        
        completeButtonEnableDriver = buttonStateDriver.filter { $0 }.map { _ in () }
        completeButtonDisableDriver = buttonStateDriver.filter { !$0 }.map { _ in () }

    }

}

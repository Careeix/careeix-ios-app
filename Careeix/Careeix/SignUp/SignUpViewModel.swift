//
//  SignUpViewModel.swift
//  Careeix
//
//  Created by κΉμ§ν on 2022/10/16.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
class SignUpViewModel {
    
    
    // MARK: SubViewModels
    let nickNameInputViewModel: SimpleInputViewModel
    let jobInputViewModel: SimpleInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobsInputViewModel: MultiInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    //    let signUpResultObservable: Observable<User>
    
    // MARK: - Input
    let createUserTrigger =  PublishRelay<Void>()
    
    // MARK: - Output
    let completeButtonEnableDriver: Driver<Void>
    let completeButtonDisableDriver: Driver<Void>
    let showTabbarCotrollerDriver: Driver<Void>
    let showAlertViewDriver: Driver<String>
    let nicknameDuplicatedDrvier: Driver<Bool>
    
    // MARK: - Initializer
    init(nickNameInputViewModel: SimpleInputViewModel, jobInputViewModel: SimpleInputViewModel, annualInputViewModel: RadioInputViewModel, detailJobsInputViewModel: MultiInputViewModel, completeButtonViewModel: CompleteButtonViewModel) {
        
        self.nickNameInputViewModel = nickNameInputViewModel
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobsInputViewModel = detailJobsInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
        
        let combinedInputValuesObservable =  Observable.combineLatest(
            nickNameInputViewModel.textfieldViewModel.inputStringRelay,
            jobInputViewModel.textfieldViewModel.inputStringRelay,
            annualInputViewModel.selectedIndexRelay,
            detailJobsInputViewModel.inputValuesObservable
        ).debug("π¦ μΈνμ΄μμ¬ ~").share()
        let result = createUserTrigger
            .withLatestFrom(combinedInputValuesObservable) { $1 }
            .map { nickname, job, annual, detailJobs in
                Entity.SignUpUser.Request(nickname: nickname, job: job, annual: annual.row, detailJobs: detailJobs)
            }.flatMap(SocialLoginSDK.socialSignUp)
            .do { UserDefaultManager.user = $0 }
            .map { $0.jwt != "" }
            .share()
        
        self.annualInputViewModel.selectedIndexRelay.accept(IndexPath(row: 4, section: 0))
        
        showTabbarCotrollerDriver = result
            .filter{ $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        let alertMessage = result
            .filter { !$0 }
            .map { _ in UserDefaultManager.user.message }
            .share()
        
        showAlertViewDriver = alertMessage
            .asDriver(onErrorJustReturn: "")
        
        nicknameDuplicatedDrvier = alertMessage
            .map { $0 == "μ€λ³΅λ λλ€μ μλλ€." }
            .asDriver(onErrorJustReturn: false)
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { nickName, job, annualIndex, detailJobs in
                nickName != ""
            }.distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        completeButtonEnableDriver = buttonStateDriver.filter { $0 }.map { _ in () }
        completeButtonDisableDriver = buttonStateDriver.filter { !$0 }.map { _ in () }
    }
    
}

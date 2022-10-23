//
//  ProjectInputViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

struct ProjectBaseInputValue: Codable {
    let title: String
    let startDateString: String
    let endDateString: String
    let division: String
    let indroduce: String
}

struct ProjectInputViewModel {
    
    let titleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let divisionInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    
    // MARK: Input
    let nextStepTrigger = PublishRelay<Void>()
    let startDateRelay = PublishRelay<Date>()
    let endDateRelay = PublishRelay<Date>()
//    let combinedInputValuesObservable: Observable<(String, String,String)>
    // MARK: Output
    let nextButtonEnableDriver: Driver<Void>
    let nextButtonDisableDriver: Driver<Void>
    let startDateStringDriver: Driver<String>
    let endDateStringDriver: Driver<String>
//    let showAddProjectDetailDriver: Driver<Void>
    let showNextViewWithInputValueDriver: Driver<ProjectBaseInputValue>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         divisionInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel) {
        self.titleInputViewModel = titleInputViewModel
        self.periodInputViewModel = periodInputViewModel
        self.divisionInputViewModel = divisionInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        let startDateStringRelay = startDateRelay
            .map { $0.toString() }
        let endDateStringRelay = endDateRelay
            .map { $0.toString() }
        let combinedInputValuesObservable = Observable.combineLatest(titleInputViewModel.inputStringRelay,
                                                                     startDateStringRelay,
                                                                     endDateStringRelay,
                                                                     divisionInputViewModel.inputStringRelay,
                                                                     introduceInputViewModel.inputStringRelay) {
            ($0, $1, $2, $3, $4)
        }
        
        startDateStringDriver = startDateRelay
            .map { $0.toString() }
            .asDriver(onErrorJustReturn: "")
        
        endDateStringDriver = endDateRelay
            .map { $0.toString() }
            .asDriver(onErrorJustReturn: "")
        
        showNextViewWithInputValueDriver = nextStepTrigger
            .withLatestFrom(combinedInputValuesObservable) { $1 }
            .map { title, startDateString, endDateString, division, introduce in
                .init(title: title, startDateString: startDateString, endDateString: endDateString, division: division, indroduce: introduce)
            }.asDriver(onErrorJustReturn: .init(title: "", startDateString: "", endDateString: "", division: "", indroduce: ""))
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { title, _, _, division, introduce in
                title != "" && division != "" && introduce != ""
            }.distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
        
        nextButtonEnableDriver = buttonStateDriver
            .filter { $0 }
            .map { _ in () }
        nextButtonDisableDriver = buttonStateDriver
            .filter { !$0 }
            .map { _ in () }
        
    }
}

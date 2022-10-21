//
//  AddProjectViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import Foundation

import RxSwift
import RxCocoa
import RxRelay

enum InputToolMove {
    case up
    case down
}

struct AddProjectViewModel {
    let titleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let divisionInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    
    let keyBoardStateRelay = PublishRelay<InputToolMove>()
    let startDatePickerViewStateRelay = PublishRelay<InputToolMove>()
    let endDatePickerViewStateRelay = PublishRelay<InputToolMove>()
    let startDatePickerViewDownDriver: Driver<Void>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         divisionInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel) {
        self.titleInputViewModel = titleInputViewModel
        self.periodInputViewModel = periodInputViewModel
        self.divisionInputViewModel = divisionInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        
        startDatePickerViewDownDriver = startDatePickerViewStateRelay
            .distinctUntilChanged()
            .filter { $0 == .down }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        
    }
}

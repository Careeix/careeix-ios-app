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

struct ProjectInputViewModel {
    
    let titleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let divisionInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    
    // MARK: Input
    let viewWillDisappearWithIsWritingRelay = PublishRelay<Bool>()

    // MARK: Output
    let nextButtonEnableDriver: Driver<Void>
    let nextButtonDisableDriver: Driver<Void>
    let showNextViewDriver: Driver<Void>
    let popViewControllerDriver: Driver<Void>
    let combinedDataDriver: Driver<ProjectBaseInputValue>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         divisionInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel) {
        self.titleInputViewModel = titleInputViewModel
        self.periodInputViewModel = periodInputViewModel
        self.divisionInputViewModel = divisionInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        let combinedInputValuesObservable = Observable.combineLatest(titleInputViewModel.inputStringRelay,
                                                                     periodInputViewModel.startDateViewModel.inputStringRelay,
                                                                     periodInputViewModel.endDateViewModel.inputStringRelay,
                                                                     divisionInputViewModel.inputStringRelay,
                                                                     introduceInputViewModel.baseTextViewModel.inputStringRelay) {
            return ($0, $1, $2, $3, $4)
        }.share()
        
        combinedDataDriver = combinedInputValuesObservable
            .map { inputs in
                ProjectBaseInputValue(title: inputs.0, startDateString: inputs.1, endDateString: inputs.2, division: inputs.3, indroduce: inputs.4, isProceed: UserDefaultManager.shared.projectInput.isProceed)
            }.asDriver(onErrorJustReturn: .init(title: "", division: "", indroduce: ""))
        
        let viewWillDisappearWithIsWritingRelayShare = viewWillDisappearWithIsWritingRelay
            .withLatestFrom(combinedInputValuesObservable) { isWriting, inputs in
                print(isWriting, inputs)
                UserDefaultManager.shared.isWritingProject = isWriting
//                UserDefaultManager.shared.projectInput = .init(title: inputs.0, startDateString: inputs.1, endDateString: inputs.2, division: inputs.3, indroduce: inputs.4, isProceed: UserDefaultManager.shared.projectInput.isProceed)
                return isWriting
            }
            .share()
        
        showNextViewDriver = viewWillDisappearWithIsWritingRelayShare
            .filter { $0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        popViewControllerDriver = viewWillDisappearWithIsWritingRelayShare
            .filter { !$0 }
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { title, _, _, division, introduce in
                title != "" && division != "" && introduce != ""
            }.distinctUntilChanged()
            .share()
            .asDriver(onErrorJustReturn: false)
        
        nextButtonEnableDriver = buttonStateDriver
            .filter { $0 }
            .map { _ in () }
        nextButtonDisableDriver = buttonStateDriver
            .filter { !$0 }
            .map { _ in () }
    }
    
    
    
    func checkRemainingData() -> Bool {
        return UserDefaultManager.shared.projectInput.checkRemain() || UserDefaultManager.shared.projectChapters.count != 0
    }
    
    func fillRemainingInput() {
        let remainigInput = UserDefaultManager.shared.projectInput
        print("리메이닝인풋: ", remainigInput)
        titleInputViewModel.inputStringRelay.accept(remainigInput.title)
        divisionInputViewModel.inputStringRelay.accept(remainigInput.division)
        periodInputViewModel.startDateViewModel.inputStringRelay.accept(remainigInput.startDateString)
        periodInputViewModel.endDateViewModel.inputStringRelay.accept(remainigInput.endDateString)
        periodInputViewModel.isSelectedProceedingRelay.accept(remainigInput.isProceed)
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(remainigInput.indroduce)
    }
}

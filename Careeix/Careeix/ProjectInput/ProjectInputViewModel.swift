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
    
    let projectId: Int
    // MARK: Input

    // MARK: Output
    let nextButtonEnableDriver: Driver<Void>
    let nextButtonDisableDriver: Driver<Void>
    let combinedDataDriver: Driver<ProjectBaseInputValue>
    let checkBoxIsSelctedDriver: Driver<Bool>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         divisionInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel, projectId: Int = -1) {
        self.projectId = projectId
        self.titleInputViewModel = titleInputViewModel
        self.periodInputViewModel = periodInputViewModel
        self.divisionInputViewModel = divisionInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        let combinedInputValuesObservable = Observable.combineLatest(titleInputViewModel.textfieldViewModel.inputStringRelay,
                                                                     periodInputViewModel.startDateViewModel.inputStringRelay,
                                                                     periodInputViewModel.endDateViewModel.inputStringRelay,
                                                                     divisionInputViewModel.textfieldViewModel.inputStringRelay,
                                                                     introduceInputViewModel.baseTextViewModel.inputStringRelay,
                                                                     periodInputViewModel.checkBoxViewModel.isSelectedRelay).skip(3).share()
        
        combinedDataDriver = combinedInputValuesObservable
            .map { inputs in
                return ProjectBaseInputValue(title: inputs.0, startDateString: inputs.1, endDateString: inputs.2, division: inputs.3, indroduce: inputs.4, isProceed: inputs.5)
            }.asDriver(onErrorJustReturn: .init(title: "", division: "", indroduce: ""))
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { title, _, _, division, introduce, _ in
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
        
        checkBoxIsSelctedDriver = periodInputViewModel.checkBoxViewModel.isSeclectedRelayShare
            .asDriver(onErrorJustReturn: false)
    }
    
    func updatePersistanceData(_ sender :ProjectBaseInputValue) {
        UserDefaultManager.shared.projectInput[projectId] = sender
    }
    
    func checkRemainingData() -> Bool {
        return UserDefaultManager.shared.projectInput[projectId] != .init(title: "", division: "", indroduce: "") || UserDefaultManager.shared.projectChapters[projectId]?.count != 0
    }
    
    func fillRemainingInput() {
        guard let remainigInput = UserDefaultManager.shared.projectInput[projectId] else { return }
        print("로컬에 저장된 데이터: ", remainigInput)
        
        titleInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.title)
        divisionInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.division)
        periodInputViewModel.startDateViewModel.inputStringRelay.accept(remainigInput.startDateString)
        periodInputViewModel.endDateViewModel.inputStringRelay.accept(remainigInput.endDateString)
        periodInputViewModel.checkBoxViewModel.isSelectedRelay.accept(remainigInput.isProceed)
        periodInputViewModel.isSelectedProceedingRelay.accept(remainigInput.isProceed)
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(remainigInput.indroduce)
    }
    
    func initProject() {
        if UserDefaultManager.shared.projectInput[projectId] == nil {
            UserDefaultManager.shared.projectInput[projectId] = .init(title: "", division: "", indroduce: "")
        }
        if UserDefaultManager.shared.projectChapters[projectId] == nil {
            UserDefaultManager.shared.projectChapters[projectId] = []
        }
    }
    
    func initPersistenceData() {
        // TODO: 수정일 경우 서버에서 받아야 함
        if projectId == -1 {
            UserDefaultManager.shared.projectInput[-1] = .init(title: "", division: "", indroduce: "")
            UserDefaultManager.shared.projectChapters[-1] = []
        } else {
            // TODO: 서버 통신
        }

    }
}

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
    
    // MARK: Properties
    let projectId: Int
    
    // MARK: SubViewModels
    let titleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let classificationInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel

    // MARK: Output
    let nextButtonEnableDriver: Driver<Void>
    let nextButtonDisableDriver: Driver<Void>
    let combinedDataDriver: Driver<ProjectBaseInputValue>
    let checkBoxIsSelctedDriver: Driver<Bool>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         classificationInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel, projectId: Int = -1) {
        self.projectId = projectId
        self.titleInputViewModel = titleInputViewModel
        self.periodInputViewModel = periodInputViewModel
        self.classificationInputViewModel = classificationInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        let combinedInputValuesObservable = Observable.combineLatest(titleInputViewModel.textfieldViewModel.inputStringRelay,
                                                                     periodInputViewModel.startDateViewModel.inputStringRelay,
                                                                     periodInputViewModel.endDateViewModel.inputStringRelay,
                                                                     classificationInputViewModel.textfieldViewModel.inputStringRelay,
                                                                     introduceInputViewModel.baseTextViewModel.inputStringRelay,
                                                                     periodInputViewModel.checkBoxViewModel.isSelectedRelay).skip(3).share()
        
        combinedDataDriver = combinedInputValuesObservable
            .map { inputs in
                return ProjectBaseInputValue(title: inputs.0, startDateString: inputs.1, endDateString: inputs.2, classification: inputs.3, introduce: inputs.4, isProceed: inputs.5)
            }.asDriver(onErrorJustReturn: .init(title: "", classification: "", introduce: ""))
        
        let buttonStateDriver = combinedInputValuesObservable
            .map { title, _, _, classification, introduce, _ in
                title != "" && classification != "" && introduce != ""
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
        
        return UserDefaultManager.shared.projectInput[projectId] != .init(title: "", classification: "", introduce: "") || UserDefaultManager.shared.projectChapters[projectId]?.count != 0
    }
    
    func fillRemainingInput() {
        guard let remainigInput = UserDefaultManager.shared.projectInput[projectId] else { return }
        print("로컬에 저장된 데이터: ", remainigInput)
        
        titleInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.title)
        classificationInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.classification)
        periodInputViewModel.startDateViewModel.inputStringRelay.accept(remainigInput.startDateString)
        periodInputViewModel.endDateViewModel.inputStringRelay.accept(remainigInput.endDateString)
        periodInputViewModel.checkBoxViewModel.isSelectedRelay.accept(remainigInput.isProceed)
        periodInputViewModel.isSelectedProceedingRelay.accept(remainigInput.isProceed)
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(remainigInput.introduce)
    }
    
    func initProject() {
        // TODO: 서버 통신 ... ?
        if UserDefaultManager.shared.projectInput[projectId] == nil {
            UserDefaultManager.shared.projectInput[projectId] = .init(title: "", classification: "", introduce: "")
        }
        if UserDefaultManager.shared.projectChapters[projectId] == nil {
            UserDefaultManager.shared.projectChapters[projectId] = []
        }
    }
    
    func initPersistenceData() {
        if projectId == -1 {
            UserDefaultManager.shared.projectInput[-1] = .init(title: "", classification: "", introduce: "")
            UserDefaultManager.shared.projectChapters[-1] = []
        } else {
            // TODO: 서버 통신 (project ID로 Project 내용 get)
        }

    }
}

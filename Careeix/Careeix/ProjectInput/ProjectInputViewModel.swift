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
    let fetchedSimpleInput: Observable<ProjectBaseInfo>
    let fetchedChapters: Observable<[ProjectChapter]>
    
    // MARK: SubViewModels
    let titleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let classificationInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    
    // MARK: Input
    let viewDidAppearRelay = PublishRelay<Void>()
    
    // MARK: Output
    let nextButtonEnableDriver: Driver<Void>
    let nextButtonDisableDriver: Driver<Void>
    let combinedDataDriver: Driver<ProjectBaseInfo>
    let checkBoxIsSelctedDriver: Driver<Bool>
    let askingKeepAlertDriver: Driver<Void>
    
    init(titleInputViewModel: SimpleInputViewModel,
         periodInputViewModel: PeriodInputViewModel,
         classificationInputViewModel: SimpleInputViewModel,
         introduceInputViewModel: ManyInputViewModel, projectId: Int = -1,
         projectRepository: ProjectRepository = ProjectRepository()
    ) {
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
                return ProjectBaseInfo(title: inputs.0, startDateString: inputs.1, endDateString: inputs.2, classification: inputs.3, introduce: inputs.4, isProceed: inputs.5)
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
        
        let projectResult = projectRepository.fetchProject(with: projectId).share()
        fetchedSimpleInput = projectId == -1
        ? .just(.init(title: "", classification: "", introduce: ""))
        : projectResult.map {
            .init(title: $0.title,
                  startDateString: $0.startDateString,
                  endDateString: $0.endDateString,
                  classification: $0.classification,
                  introduce: $0.introduce, isProceed: $0.isProceed == 1 ? true : false)
        }
        
        fetchedChapters = projectId == -1
        ? .just([])
        : projectResult.map { $0.projectChapters }
        
        let performViewDidAppear = viewDidAppearRelay
            .filter { UserDefaultManager.writingProjectId != projectId }
            .do { _ in UserDefaultManager.writingProjectId = projectId }
        
        let initialFetchData = Observable.combineLatest(performViewDidAppear, fetchedSimpleInput, fetchedChapters)
            .catch { error in
                NotificationCenter.default.post(name: Notification.Name(rawValue: "projectFetchError"), object: nil)
                return Observable.create { observer in
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .map { ($0.1, $0.2) }
            .do {
                if  UserDefaultManager.projectBaseInputCache[projectId] == nil &&
                        UserDefaultManager.projectChaptersInputCache[projectId] == nil {
                    UserDefaultManager.projectBaseInputCache[projectId] = $0.0
                    UserDefaultManager.projectChaptersInputCache[projectId] = $0.1
                }
            }
            .share()
        
        let isNotSameData = initialFetchData
            .filter { $0.0 != UserDefaultManager.projectBaseInputCache[projectId] || $0.1 != UserDefaultManager.projectChaptersInputCache[projectId] }
            .do {
                print("🥸🥸🥸🥸")
                print($0)
                print(UserDefaultManager.projectBaseInputCache[projectId])
                print(UserDefaultManager.projectChaptersInputCache[projectId])
                UserDefaultManager.projectBaseInputCache[-2] = $0.0
                UserDefaultManager.projectChaptersInputCache[-2] = $0.1
            }
        
        // 프로젝트를 가지고 (유저디폴트에 값이 있으면) 이어서 수정하시겠습니까를 띄어야 하는지 판단 ->
        // 이어서 수정하기 -> 유저디폴트 값유지
        // 이어서 수정안하기 -> 새로운 데이터로 유저 디폴트 값 저장 -> (등록이면 초기화값, 수정이면 서버에서 패치해온값)
        
        askingKeepAlertDriver = isNotSameData
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
    }
    
    func updatePersistanceData(_ sender :ProjectBaseInfo) {
        UserDefaultManager.projectBaseInputCache[projectId] = sender
    }
    
    func checkRemainingData() -> Bool {
        return projectId == -1 && (
            UserDefaultManager.projectBaseInputCache[projectId] != .init(title: "", classification: "", introduce: "")
            || UserDefaultManager.projectChaptersInputCache[projectId]?.count != 0)
    }
    
    func fillRemainingInput() {
        guard let remainigInput = UserDefaultManager.projectBaseInputCache[projectId] else { return }
        titleInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.title)
        classificationInputViewModel.textfieldViewModel.inputStringRelay.accept(remainigInput.classification)
        periodInputViewModel.checkBoxViewModel.isSelectedRelay.accept(remainigInput.isProceed)
        periodInputViewModel.startDateViewModel.inputStringRelay.accept(remainigInput.startDateString)
        periodInputViewModel.endDateViewModel.inputStringRelay.accept(remainigInput.endDateString ?? Date().toString())
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(remainigInput.introduce)
    }
    
    func initProject() {
        if projectId == -1 {
            if UserDefaultManager.projectBaseInputCache[projectId] == nil {
                UserDefaultManager.projectBaseInputCache[projectId] = .init(title: "", classification: "", introduce: "")
            }
            if UserDefaultManager.projectChaptersInputCache[projectId] == nil {
                UserDefaultManager.projectChaptersInputCache[projectId] = []
            }
        }
    }
    
    func initPersistenceData() {
        if projectId == -1 {
            UserDefaultManager.projectBaseInputCache[-1] = .init(title: "", classification: "", introduce: "")
            UserDefaultManager.projectChaptersInputCache[-1] = []
        } else {
            UserDefaultManager.projectBaseInputCache[projectId] = UserDefaultManager.projectBaseInputCache[-2]
            UserDefaultManager.projectChaptersInputCache[projectId] = UserDefaultManager.projectChaptersInputCache[-2]
            fillRemainingInput()
        }
    }
    
    func deinitVC() {
        UserDefaultManager.writingProjectId = -2
        UserDefaultManager.projectBaseInputCache[-2] = nil
        UserDefaultManager.projectChaptersInputCache[-2] = nil
    }
}

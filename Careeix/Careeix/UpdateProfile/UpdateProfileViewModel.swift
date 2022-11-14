//
//  UpdateProfileViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/11.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class UpdateProfileViewModel {
    typealias job = String
    typealias annual = Int
    typealias detailJobs = [String]
    typealias introduce = String
    
    
    
    // MARK: SubViewModels
    let jobInputViewModel: SimpleInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobsInputViewModel: MultiInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    // MARK: Inputs
    let viewDidLoadRelay = PublishRelay<Void>()
    let completeButtonTrigger = PublishRelay<Void>()
    
    // MARK: Outputs
    let fillDataDriver: Driver<(job, annual, detailJobs, introduce)>
    let alertDriver: Driver<String>
    let updateDataDriver: Driver<(job, annual, detailJobs, introduce)>
    
    init(jobInputViewModel: SimpleInputViewModel,
         annualInputViewModel: RadioInputViewModel,
         detailJobsInputViewModel: MultiInputViewModel,
         introduceInputViewModel: ManyInputViewModel,
         completeButtonViewModel: CompleteButtonViewModel,
         userRepository: UserRepository = UserRepository()
    ) {
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobsInputViewModel = detailJobsInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
        
        fillDataDriver = viewDidLoadRelay
            .debug("viewdidLoad")
            .map { _ in
                let user = UserDefaultManager.user
                return (user.userJob, user.userWork, user.userDetailJobs, user.userIntro ?? "")
            }.asDriver(onErrorJustReturn: ("", 0, [], ""))
        
        // NOTE: 마지막값 안들어온다
        let combinedInputValuesObservable =  Observable.combineLatest(
            jobInputViewModel.textfieldViewModel.inputStringRelay,
            annualInputViewModel.selectedIndexRelay,
            detailJobsInputViewModel.inputValuesObservable,
            introduceInputViewModel.baseTextViewModel.inputStringRelay
        ){ ($0, $1.row, $2, $3) }.share().debug("🐷")

        let result = completeButtonTrigger
            .withLatestFrom(combinedInputValuesObservable)
            .map { UpdateProfileModel(userDetailJob: $0.2, userIntro: $0.3, userJob: $0.0, userWork: $0.1) }
            .flatMap(userRepository.updateProfile)
            .share()
        
        alertDriver = result
            .map { $0.message }
            .asDriver(onErrorJustReturn: "")
        
        updateDataDriver = result.filter { $0.code == "200" }
            .withLatestFrom(combinedInputValuesObservable)
            .asDriver(onErrorJustReturn: ("", 0, [], ""))
    }
    
    func updateUser(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
        UserDefaultManager.user.userJob = job
        UserDefaultManager.user.userWork = annual
        UserDefaultManager.user.userDetailJobs = detailJobs
        UserDefaultManager.user.userIntro = introduce
    }
    
    func fillData(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
        jobInputViewModel.textfieldViewModel.inputStringRelay.accept(job)
        annualInputViewModel.selectedIndexRelay.accept(IndexPath(row: annual, section: 0))
        zip(detailJobsInputViewModel.multiInputCellViewModels, detailJobs).forEach {
            $0.0.textFieldViewModel.inputStringRelay.accept($0.1)
        }
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(introduce)
    }
}

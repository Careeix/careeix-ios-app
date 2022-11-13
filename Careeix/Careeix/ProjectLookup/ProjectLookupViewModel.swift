//
//  ProjectLookupViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ProjectLookupViewModel {
    let projectId: Int
    var title: String = ""
    let isWriting: Bool
    
    let projectRepository: ProjectRepository
    
    let projectBaseInfo: Observable<ProjectBaseInfo>
    let projectChapters: Observable<[ProjectChapter]>
    
    // MARK: Input
    let updateTrigger = PublishRelay<Void>()
    
    // MARK: Output
    let headerViewDataDriver: Driver<ProjectBaseInfo>
    let lookupCellDataDriver: Driver<[ProjectChapter]>
    let showPrevViewDriver: Driver<Void>
    let showErrorAlertViewDriver: Driver<String>
    
    init(projectId: Int, projectRepository: ProjectRepository = ProjectRepository()) {
        self.projectId = projectId
        self.projectRepository = projectRepository
        
        isWriting = UserDefaultManager.writingProjectId != -2
        
        if isWriting {
            projectBaseInfo = .just(UserDefaultManager.projectBaseInputCache[projectId]!)
            projectChapters = .just(UserDefaultManager.projectChaptersInputCache[projectId]!)
        } else {
            let fetchedProject = projectRepository.fetchProject(with: projectId).share()
            projectBaseInfo = fetchedProject.map {
                .init(title: $0.title,
                      startDateString: $0.startDateString,
                      endDateString: $0.endDateString,
                      classification: $0.classification,
                      introduce: $0.introduce,
                      isProceed: $0.isProceed == 1 ? true : false)
            }
            projectChapters = fetchedProject.map { $0.projectChapters }
        }
        
        lookupCellDataDriver = projectChapters
            .asDriver(onErrorJustReturn: [])
        
        headerViewDataDriver = projectBaseInfo
            .asDriver(onErrorJustReturn: .init(title: "", classification: "", introduce: ""))
        
        let updateResult = updateTrigger
            .flatMap { projectRepository.updateProject(with: projectId, project: project()) }
            .share()
            
        
        showPrevViewDriver = updateResult
            .filter { $0.code == "200" }
            .map { _ in () }
            .do { _ in deleteProject() }
            .asDriver(onErrorJustReturn: ())
        
        showErrorAlertViewDriver = updateResult
            .filter { $0.code != "200" }
            .compactMap { $0.message }
            .asDriver(onErrorJustReturn: "")
        
        
        func project() -> Project {
            guard let baseInput = UserDefaultManager.projectBaseInputCache[projectId], let chapterInput = UserDefaultManager.projectChaptersInputCache[projectId] else { return .init() }
            
            return .init(title: baseInput.title,
                         startDateString: baseInput.startDateString,
                         endDateString: baseInput.isProceed
                         ? nil
                         : baseInput.endDateString,
                         classification: baseInput.classification,
                         introduce: baseInput.introduce,
                         isProceed: baseInput.isProceed
                         ? 1
                         : 0,
                         projectChapters: chapterInput)
        }
        
        func deleteProject() {
            UserDefaultManager.projectBaseInputCache[projectId] = nil
            UserDefaultManager.projectChaptersInputCache[projectId] = nil
        }
    }
    
    
}

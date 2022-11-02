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
    
    let projectBaseInfo: Observable<ProjectBaseInfo>
    let projectChapters: Observable<[ProjectChapter]>
    
    // MARK: Output
    let headerViewDataDriver: Driver<ProjectBaseInfo>
    let lookupCellDataDriver: Driver<[ProjectChapter]>
    
    init(projectId: Int) {
        self.projectId = projectId
        isWriting = UserDefaultManager.writingProjectId != -2
        
        if isWriting {
            projectBaseInfo = .just(UserDefaultManager.projectBaseInputCache[projectId]!)
            projectChapters = .just(UserDefaultManager.projectChaptersInputCache[projectId]!)
        } else {
            let fetchedProject = ProjectNetworkManager.fetchProject(with: projectId).share()
            projectBaseInfo = fetchedProject.map {
                .init(title: $0.title,
                      startDateString: $0.startDateString,
                      endDateString: $0.endDateString,
                      classification: $0.classification,
                      introduce: $0.introduce,
                      isProceed: $0.isProceed)
            }
            projectChapters = fetchedProject.map { $0.projectChapters }
        }
        
        lookupCellDataDriver = projectChapters
            .asDriver(onErrorJustReturn: [])
        
        headerViewDataDriver = projectBaseInfo
            .asDriver(onErrorJustReturn: .init(title: "", classification: "", introduce: ""))
    }
    
    func createProject() {
        print("발행전 데이터 확인")
        print(projectId)
        print(UserDefaultManager.jwtToken)
        print(UserDefaultManager.projectBaseInputCache[projectId])
        print(UserDefaultManager.projectChaptersInputCache[projectId])
        //        // TODO: 서버 통신 (프로젝트 post)
        //        deleteProject()
    }
    
    func deleteProject() {
        UserDefaultManager.projectBaseInputCache[projectId] = nil
        UserDefaultManager.projectChaptersInputCache[projectId] = nil
    }
}

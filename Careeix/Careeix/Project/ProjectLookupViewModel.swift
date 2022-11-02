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

struct ProjectLookupViewModel {
    let topInset: CGFloat
    let projectId: Int
    let completeButtonIsHidden: Bool
    let lookUpCellDataDriver: Driver<[String]>
    
    init(type: ProjectViewType) {
        self.projectId = UserDefaultManager.shared.currentWritingProjectId
        self.topInset = type.inset()
        lookUpCellDataDriver = .just(UserDefaultManager.shared.projectChapters[projectId]?.map { $0.title } ?? [])
        completeButtonIsHidden = type.completeButtonIsHidden()
    }
    
//    func project() -> Project {
//        if projectId == -1 {
//            
//        }
//    }
    
    func createProject() {
        print("발행전 데이터 확인")
        print(projectId)
        print(UserDefaultManager.shared.jwtToken)
        print(UserDefaultManager.shared.projectInput[projectId])
        print(UserDefaultManager.shared.projectChapters[projectId])
        //        // TODO: 서버 통신 (프로젝트 post)
//        deleteProject()
    }
    
    func deleteProject() {
        UserDefaultManager.shared.projectInput[projectId] = nil
        UserDefaultManager.shared.projectChapters[projectId] = nil
    }
}

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
    let projectId: Int
    let topInset: CGFloat
//    let project: Project
    
//    let completeButtonIsHidden: Bool
    let lookUpCellDataDriver: Driver<[String]>
    
    init(projectId: Int) {
        self.projectId = projectId
        let isWriting = UserDefaultManager.writingProjectId != -2
        self.topInset = isWriting ? 30 : 14
        let projectBaseInput = UserDefaultManager.projectBaseInputCache[projectId] ?? .init(title: "", classification: "", introduce: "")
        let projectChapterInput = UserDefaultManager.projectChaptersInputCache[projectId]
        lookUpCellDataDriver = .just(UserDefaultManager.projectChaptersInputCache[projectId]?.map { $0.title } ?? [])
//        completeButtonIsHidden = type.completeButtonIsHidden()
        
    }
    
//    func project() -> Project {
//        if projectId == -1 {
//            
//        }
//    }
    
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

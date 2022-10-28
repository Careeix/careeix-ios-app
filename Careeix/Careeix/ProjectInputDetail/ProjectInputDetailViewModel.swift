//
//  ProjectInputDetailViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/29.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

struct ProjectInputDetailViewModel {
    let projectId: Int
    
    // MARK: Input
    let viewWillAppearRelay = PublishRelay<Void>()
    let createTrigger = PublishRelay<Void>()
    
    // MARK: Output
    let chaptersDriver: Driver<[ProjectChapter]>
    let createIndexDriver: Driver<Int>
    let updateTableViewHeightDriver: Driver<CGFloat>
    
    init(projectId: Int = -1) {
        self.projectId = projectId
        
        chaptersDriver = viewWillAppearRelay
            .compactMap { _ in UserDefaultManager.shared.projectChapters[projectId] }
            .asDriver(onErrorJustReturn: [])
        
        createIndexDriver = createTrigger
            .compactMap { _ in UserDefaultManager.shared.projectChapters[projectId]?.count }
            .asDriver(onErrorJustReturn: 0)
        
        updateTableViewHeightDriver = viewWillAppearRelay
            .compactMap { _ in UserDefaultManager.shared.projectChapters[projectId]?.count }
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
    }
    
    func createProject() {
        // TODO: 서버 통신
        print("발행전 데이터 확인")
        print(UserDefaultManager.shared.jwtToken)
        print(UserDefaultManager.shared.projectInput[projectId])
        print(UserDefaultManager.shared.projectChapters[projectId])
    }
}

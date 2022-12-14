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
    
    init() {
        let projectId = UserDefaultManager.writingProjectId
        self.projectId = projectId
        
        chaptersDriver = viewWillAppearRelay
            .compactMap { _ in UserDefaultManager.projectChaptersInputCache[projectId] }
            .asDriver(onErrorJustReturn: [])
        
        createIndexDriver = createTrigger
            .compactMap { _ in UserDefaultManager.projectChaptersInputCache[projectId]?.count }
            .asDriver(onErrorJustReturn: 0)
        
        updateTableViewHeightDriver = viewWillAppearRelay
            .compactMap { _ in UserDefaultManager.projectChaptersInputCache[projectId]?.count }
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
    }
    


}

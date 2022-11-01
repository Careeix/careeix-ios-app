//
//  ProjectChapterInputViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class ProjectChapterInputViewModel {
    // MARK: Properties
    var noteCellViewModels: [NoteCellViewModel] = [] {
        didSet {
            cellDataRelay.accept(noteCellViewModels)
        }
    }
    let currentIndex: Int
    let projectId: Int
    // MARK: - SubViewModels
    let titleTextFieldViewModel: BaseTextFieldViewModel
    let contentViewModel: BaseTextViewModel
    
    // MARK: - Input
    let cellDataRelay = BehaviorRelay<[NoteCellViewModel]>(value: [])
    let noteTableViewHeightRelay = PublishRelay<CGFloat>()
    let updateTableViewHeightTriggerRelay = PublishRelay<Void>()
    let scrollToHeightRelay = PublishRelay<CGFloat>()
    
    // MARK: - Output
    let updateProjectChapterDriver: Driver<ProjectChapter>
    let cellDataDriver: Driver<[NoteCellViewModel]>
    let canAddNoteDriver: Driver<Bool>
    let noteTableViewHeightDriver: Driver<CGFloat>
    let scrollToHeightDriver: Driver<CGFloat>
    let completeButtonEnableDriver: Driver<Bool>
    
    // MARK: - Initializer
    init(currentIndex: Int, projectId: Int = -1) {
        self.projectId = projectId
        self.currentIndex = currentIndex
        self.titleTextFieldViewModel = .init()
        self.contentViewModel = .init()
        
        let combinedInputValuesObservableShare = Observable.combineLatest(titleTextFieldViewModel.inputStringRelay, contentViewModel.inputStringRelay)
        
        let combinedDataShare = cellDataRelay
            .map { Observable.combineLatest(combinedInputValuesObservableShare, Observable.combineLatest($0.map {$0.inputStringRelay})) }
            .flatMap { $0 }
            .map { ProjectChapter(title: $0.0, content: $0.1, notes: $1 ) }.skip(1)
        
        
        updateProjectChapterDriver = combinedDataShare
            .asDriver(onErrorJustReturn: .init(title: "", content: "", notes: []))
        
        completeButtonEnableDriver = combinedDataShare
            .distinctUntilChanged()
            .map { $0 != ProjectChapter(title: "", content: "", notes: [])}
            .asDriver(onErrorJustReturn: false)
        
        let cellDataRelayShare = cellDataRelay.share()
        
        cellDataDriver = cellDataRelayShare
            .asDriver(onErrorJustReturn: [])
        
        canAddNoteDriver = cellDataRelayShare.map { $0.count }
            .map { $0 < 3 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
        
        noteTableViewHeightDriver = noteTableViewHeightRelay
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
        
        scrollToHeightDriver = scrollToHeightRelay
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
    }
    
    func fillInputs() {
        if checkProjectChaptersRange() {
            guard let needFillData = UserDefaultManager.shared.projectChapters[projectId]?[currentIndex] else { return }
            titleTextFieldViewModel.inputStringRelay.accept(needFillData.title)
            contentViewModel.inputStringRelay.accept(needFillData.content)
            noteCellViewModels = needFillData.notes.map { .init(inputStringRelay: BehaviorRelay(value: $0)) }
        }
    }
    
    func updateProjectChapter(data: ProjectChapter) {
        checkProjectChaptersRange()
        ? UserDefaultManager.shared.projectChapters[projectId]?[currentIndex] = data
        : nil
    }
    
    func updateProjectChapter() {
        checkProjectChaptersRange()
        ? nil
        : UserDefaultManager.shared.projectChapters[projectId]?.append(.init(title: "", content: "", notes: []))
    }
    
    func checkProjectChaptersRange() -> Bool {
        guard let data = UserDefaultManager.shared.projectChapters[projectId] else { return false }
        return data.count > currentIndex
    }
    
    func checkAndRemove() {
        if currentIndex < UserDefaultManager.shared.projectChapters.count {
            guard let currentChapter = UserDefaultManager.shared.projectChapters[projectId]?[currentIndex] else { return }
            if currentChapter.content == ""
                && currentChapter.title == ""
                && currentChapter.notes.isEmpty {
                UserDefaultManager.shared.projectChapters[projectId]?.remove(at: currentIndex)
            }
        }
    }
}
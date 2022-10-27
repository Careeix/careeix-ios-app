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
    
    // MARK: - SubViewModels
    let titleTextFieldViewModel: BaseTextFieldViewModel
    let contentViewModel: BaseTextViewModel
    
    // MARK: - Input
    let cellDataRelay = BehaviorRelay<[NoteCellViewModel]>(value: [])
    let noteTableViewHeightRelay = PublishRelay<CGFloat>()
    let updateTableViewHeightTriggerRelay = PublishRelay<Void>()
    let scrollToHeightRelay = PublishRelay<CGFloat>()
    
    // MARK: - Output
//    let combinedDataDriver: Driver<ProjectChapter>
    let cellDataDriver: Driver<[NoteCellViewModel]>
    let canAddNoteDriver: Driver<Bool>
    let noteTableViewHeightDriver: Driver<CGFloat>
    let scrollToHeightDriver: Driver<CGFloat>
    
    // MARK: - Initializer
    init(currentIndex: Int) {
        self.currentIndex = currentIndex
        self.titleTextFieldViewModel = .init()
        self.contentViewModel = .init()
        
        let combinedInputValuesObservableShare = Observable.combineLatest(titleTextFieldViewModel.inputStringRelay, contentViewModel.inputStringRelay, cellDataRelay).share()
        
        combinedInputValuesObservableShare.subscribe {
            print("모은데이터 들이야 ~", $0, $1, $2.map { $0.textViewModel.inputStringRelay.value })
        }
        
//        Observable.combineLatest(cell)
//            .debug("노트들")
//            .subscribe { notes in
//                print(notes)
//            }
        
        let cellDataRelayShare = cellDataRelay.share()
        
        cellDataDriver = cellDataRelayShare.asDriver(onErrorJustReturn: [])
        
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
        if currentIndex < UserDefaultManager.shared.projectChapters.count {
            let needFillData = UserDefaultManager.shared.projectChapters[currentIndex]
            titleTextFieldViewModel.inputStringRelay.accept(needFillData.title)
            contentViewModel.inputStringRelay.accept(needFillData.content)
            noteCellViewModels = needFillData.notes.filter { !$0.isEmpty }.enumerated().map { .init(inputStringRelay: BehaviorRelay<String>(value: $1), row: $0, textViewModel: .init(inputStringRelay: BehaviorRelay<String>(value: $1))) }
        }
//        updateTableViewHeightTriggerRelay.accept(())
    }
    
    func updateProjectChapter(title: String, content: String) {
        if checkProjectChaptersRange() {
            UserDefaultManager.shared.projectChapters[currentIndex].title = title
            UserDefaultManager.shared.projectChapters[currentIndex].content = content
        }
    }
    
    func updateProjectChapter(notes: [String]) {
        checkProjectChaptersRange()
        ? UserDefaultManager.shared.projectChapters[currentIndex].notes = notes
        : nil
    }
    func updateProjectChapter() {
        checkProjectChaptersRange()
        ? nil
        : UserDefaultManager.shared.projectChapters.append(.init(title: "", content: "", notes: []))
    }
    
    func checkProjectChaptersRange() -> Bool {
        UserDefaultManager.shared.projectChapters.count > currentIndex
    }
}

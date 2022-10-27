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
    var noteCellViewModels: [NoteCellViewModel] = [] {
        didSet {
            cellDataRelay.accept(noteCellViewModels)
        }
    }
    let currentIndex: Int
    let titleTextFieldViewModel: BaseTextFieldViewModel
    let contentViewModel: BaseTextViewModel
    // MARK: Input
    let cellDataRelay = BehaviorRelay<[NoteCellViewModel]>(value: [])
    let noteTableViewHeightRelay = PublishRelay<CGFloat>()
    let updateTableViewHeightTriggerRelay = PublishRelay<Void>()
    let scrollToHeightRelay = PublishRelay<CGFloat>()
    // MARK: Output
    let cellDataDriver: Driver<[NoteCellViewModel]>
    let canAddNoteDriver: Driver<Bool>
    let noteTableViewHeightDriver: Driver<CGFloat>
    let scrollToHeightDriver: Driver<CGFloat>
    init(currentIndex: Int) {
        self.titleTextFieldViewModel = .init()
        self.contentViewModel = .init()
//        let combinedInputValuesObservable =
        let combinedInputValuesObservable = Observable.combineLatest(titleTextFieldViewModel.inputStringShare, contentViewModel.inputStringShare) { ($0, $1) }

        combinedInputValuesObservable.subscribe {
            print("모은데이터 들이야 ~", $0, $1)
        }

        Observable.combineLatest(noteCellViewModels.map {$0.inputStringRelay})
            .debug("노트들")
            .subscribe { notes in
                print(notes)
            }
        self.currentIndex = currentIndex
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
            print("ㅁㄴㄴㄴㄴ아래 내용을 채워야해요")
            print(UserDefaultManager.shared.projectChapters[currentIndex])
            let needFillData = UserDefaultManager.shared.projectChapters[currentIndex]
            titleTextFieldViewModel.inputStringRelay.accept(needFillData.title)
            contentViewModel.inputStringRelay.accept(needFillData.content)
            noteCellViewModels = needFillData.notes.filter { !$0.isEmpty }.enumerated().map { .init(inputStringRelay: BehaviorRelay<String>(value: $1), row: $0)}
        }
        updateTableViewHeightTriggerRelay.accept(())
    }
    func updateProjectChapter() {
        let title = titleTextFieldViewModel.inputStringRelay.value
        let content = contentViewModel.inputStringRelay.value
        //TODO: !!!!!!!!!
        print("이놈들의 왜 비어있을까? ", title, content)
        if currentIndex == UserDefaultManager.shared.projectChapters.count {
            UserDefaultManager.shared.projectChapters.append(.init(title: title, content: content, notes: noteCellViewModels.map { $0.inputStringRelay.value }))
        } else if  currentIndex < UserDefaultManager.shared.projectChapters.count {
            UserDefaultManager.shared.projectChapters[currentIndex] = .init(title: title, content: content, notes: noteCellViewModels.map { $0.inputStringRelay.value }.filter { !$0.isEmpty } )
        }
        print(UserDefaultManager.shared.projectChapters)
        
    }
}

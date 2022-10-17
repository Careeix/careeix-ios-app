//
//  SignUpViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/16.
//

import Foundation
import RxCocoa
import RxSwift
import RxRelay
struct CompleteButtonViewModel {
    let content: String
    let backgroundColor: AssetsColor
    
    init(content: String, backgroundColor: AssetsColor) {
        self.content = content
        self.backgroundColor = backgroundColor
    }
}
struct RadioInputViewModel {
    let title: String
//    let contents: [String]
    var selected: Int?
    
    // MARK: - Output
    let contentsDriver: Driver<[String]>
    
    init(title: String, contents: [String]) {
        self.title = title
        contentsDriver = Observable.just(contents).asDriver(onErrorJustReturn: [])
    }
}

struct BaseInputViewModel {
    let title: String
    let placeholder: String

    // MARK: - Input
    let inputTextRelay = BehaviorRelay<String>(value: "")
    init(title: String, placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }
}

struct MultiInputViewModel {
    let title: String
    let placeholders: [String]
    var inputValues: [PublishRelay<String>]
    init(title: String, placeholders: [String]) {
        self.title = title
        self.placeholders = placeholders
        self.inputValues = Array(repeating: PublishRelay<String>(), count: placeholders.count)
    }
}

struct SignUpViewModel {
    let nickNameInputViewModel: BaseInputViewModel
    let jobInputViewModel: BaseInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobInputViewModel: MultiInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    init(nickNameInputViewModel: BaseInputViewModel, jobInputViewModel: BaseInputViewModel, annualInputViewModel: RadioInputViewModel, detailJobInputViewModel: MultiInputViewModel, completeButtonViewModel: CompleteButtonViewModel) {
        self.nickNameInputViewModel = nickNameInputViewModel
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobInputViewModel = detailJobInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
    }
}

//
//  BaseTextView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay
struct BaseTextViewModel {
    let limitLines: Int
    let inputRelay = PublishRelay<String>()
    
    let driver: Driver<String>
    
    init(limitLines: Int) {
        self.limitLines = limitLines
        driver = inputRelay.asDriver(onErrorJustReturn: "")
    }
}
class BaseTextView: UITextView {
    let viewModel = BaseTextViewModel(limitLines: 2)
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        configure()
    }
    var disposeBag = DisposeBag()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        rx.text.orEmpty
            .bind(to: viewModel.inputRelay).disposed(by: disposeBag)
        // TODO: !!!
        viewModel.driver
            .drive { _ in
            }.disposed(by: disposeBag)
        
        translatesAutoresizingMaskIntoConstraints = true
        sizeToFit()
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        font = .pretendardFont(size: 13, style: .regular)
        isScrollEnabled = false
    }
}

extension Reactive where Base: BaseTextView {
    var text: ControlProperty<String?> {
        value
    }
}

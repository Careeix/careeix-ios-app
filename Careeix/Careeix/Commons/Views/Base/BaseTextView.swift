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
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//
//
//
//    }
    var disposeBag = DisposeBag()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        rx.text.orEmpty
            .bind(to: viewModel.inputRelay).disposed(by: disposeBag)
        viewModel.driver
            .drive { a in
                print(a, a.contains("\n"))
            }.disposed(by: disposeBag)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        font = .pretendardFont(size: 13, style: .regular)
    }
}

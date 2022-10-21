//
//  BaseInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

struct SimpleInputViewModel {
    // MARK: - Input
    let inputStringRelay = PublishRelay<String>()
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    let placeholderStringDriver: Driver<String>
    init(title: String, placeholder: String) {
        titleStringDriver = .just(title)
        placeholderStringDriver = .just(placeholder)
    }
}

class SimpleInputView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: SimpleInputViewModel) {
        viewModel.titleStringDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.placeholderStringDriver
            .drive(textField.rx.placeholder)
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)
    }
    
    // MARK: Initializer
    init(viewModel: SimpleInputViewModel) {
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        l.textColor = .appColor(.gray900)
        return l
    }()
    var textField: BaseTextField = BaseTextField()
    
    
    func setUI() {
        [titleLabel, textField].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview()
        }
    }
}

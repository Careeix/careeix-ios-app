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
    let textfieldViewModel: BaseTextFieldViewModel
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    init(title: String, textFieldViewModel: BaseTextFieldViewModel) {
        self.textfieldViewModel = textFieldViewModel
        titleStringDriver = .just(title)
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
    }
    
    // MARK: Initializer
    init(viewModel: SimpleInputViewModel) {
        textField = BaseTextField(viewModel: viewModel.textfieldViewModel)
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
        textField.setPlaceholder()
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
    var textField: BaseTextField
    
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

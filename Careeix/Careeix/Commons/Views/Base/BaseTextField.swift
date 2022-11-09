//
//  BaseTextField.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
/// no intrinsic size
/// intrinsic size 없습니다
class BaseTextFieldViewModel {
    // MARK: Input
    let inputStringRelay: BehaviorRelay<String>
    
    // MARK: Output
    let inputStringDriver: Driver<String>
    let placeholderDriver: Driver<String>

    init(placeholder: String = "내용을 입력해주세요.", inputStringRelay: BehaviorRelay<String> = BehaviorRelay<String>(value: "")) {
        self.inputStringRelay = inputStringRelay
        placeholderDriver = .just(placeholder)
        inputStringDriver = inputStringRelay
            .asDriver(onErrorJustReturn: "")
    }
}
class BaseTextField: UITextField {
    var disposeBag = DisposeBag()
    
    init(viewModel: BaseTextFieldViewModel) {
        super.init(frame: .zero)
        configure()
        bind(to: viewModel)
        delegate = self
    }
    
    func bind(to viewModel: BaseTextFieldViewModel) {
        rx.text.orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)
        
        viewModel.placeholderDriver
            .drive(rx.placeholder)
            .disposed(by: disposeBag)
        
        viewModel.inputStringDriver
            .drive(rx.text)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlaceholder(textColor: UIColor = .appColor(.gray250), fontSize: CGFloat = 12, font: UIFont.FontType.Pretentdard = .regular) {
        guard let string = placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [
            .foregroundColor: textColor,
            .font: UIFont.pretendardFont(size: fontSize, style: font)
        ])
    }
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        setLeftPaddingPoints(15)
        font = .pretendardFont(size: 13, style: .regular)
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: UIColor.appColor(.gray250)])
    }
}

extension BaseTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text else { return false }
        return text.count < 25 || range.length == 1
    }
}


//
//  ManyInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

struct ManyInputViewModel {
    let baseTextViewModel: BaseTextViewModel
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    init(title: String, baseTextViewModel: BaseTextViewModel) {
        titleStringDriver = .just(title)
        self.baseTextViewModel = baseTextViewModel
    }
}

class ManyInputView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
    var viewModel: ManyInputViewModel
    
    // MARK: - Binding
    func bind(to viewModel: ManyInputViewModel) {
        viewModel.titleStringDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: Initializer
    init(viewModel: ManyInputViewModel) {
        self.viewModel = viewModel
        textView = BaseTextView(viewModel: viewModel.baseTextViewModel)
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
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
    var textView: BaseTextView
    
    func setUI() {
        [titleLabel, textView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.height.equalTo(91)
            $0.bottom.equalToSuperview()
        }
    }
}

//
//  PeriodInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

struct PeriodInputViewModel {
    
    let startDateViewModel: BaseInputViewModel
    let endDateViewModel: BaseInputViewModel
    
    // MARK: Input
    let startDateTappedRelay = PublishRelay<Void>()
    let endDateTappedRelay = PublishRelay<Void>()
    
    // MARK: Output
    let titleDriver: Driver<String>
    let descriptionDriver: Driver<String>
    //    let startDateDriver: Driver<String>
    //    let endDateDriver: Driver<String>
    init(title: String, description: String) {
        titleDriver = .just(title)
        descriptionDriver = .just(description)
        startDateViewModel = .init(content: Date().toString())
        endDateViewModel = .init(content: Date().toString())
    }
}

class PeriodInputView: UIView {
    let disposeBag = DisposeBag()
    
    func bind(to viewModel: PeriodInputViewModel) {
        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    init(viewModel: PeriodInputViewModel) {
        startDateView = .init(viewModel: viewModel.startDateViewModel)
        endDateView = .init(viewModel: viewModel.endDateViewModel)
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 12, style: .regular)
        return l
    }()
    let startDateView: BaseInputView
    let endDateView: BaseInputView
    let middleLabel: UILabel = {
        let l = UILabel()
        l.text = "~"
        l.textColor = .appColor(.gray600)
        l.font = .pretendardFont(size: 16, style: .semiBold)
        return l
    }()
    let proceedingCheckBox = BaseCheckBoxView()
    let proceedingLabel: UILabel = {
        let l = UILabel()
        l.text = "진행 중"
        l.textColor = .appColor(.error)
        l.font = .pretendardFont(size: 12, style: .regular)
        return l
    }()
}

extension PeriodInputView {
    func setUI() {
        [titleLabel, descriptionLabel, startDateView, middleLabel, endDateView, proceedingCheckBox, proceedingLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel)
        }
        
        middleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
        
        startDateView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(middleLabel.snp.leading).offset(-6)
            $0.height.equalTo(48)
            $0.centerY.equalTo(middleLabel)
        }
        
        endDateView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(middleLabel.snp.trailing).offset(6)
            $0.height.equalTo(48)
            $0.centerY.equalTo(middleLabel)
        }
        
        proceedingCheckBox.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.leading.equalTo(endDateView)
            $0.top.equalTo(endDateView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }

        proceedingLabel.snp.makeConstraints {
            $0.leading.equalTo(proceedingCheckBox.snp.trailing).offset(8)
            $0.top.equalTo(endDateView.snp.bottom).offset(11)
        }
    }
}

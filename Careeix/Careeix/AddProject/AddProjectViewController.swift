//
//  AddProjectViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

class AddProjectViewController: UIViewController {
    // MARK: Properties
    
    init(viewModel: AddProjectViewModel) {
        titleSimpleInputView = .init(viewModel: viewModel.titleSimpleInputViewModel)
        periodInputView = .init(viewModel: viewModel.periodInputViewModel)
        divisionInputView = .init(viewModel: viewModel.divisionInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        super.init(nibName: nil, bundle: nil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UIComponents
    //    let progressView
    let titleSimpleInputView: SimpleInputView
    let periodInputView: PeriodInputView
    let divisionInputView: SimpleInputView
    let introduceInputView: ManyInputView
}

extension AddProjectViewController {
    func setUI() {
        [titleSimpleInputView, periodInputView, divisionInputView, introduceInputView].forEach { view.addSubview($0) }
        
        titleSimpleInputView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        periodInputView.snp.makeConstraints {
            $0.top.equalTo(titleSimpleInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        divisionInputView.snp.makeConstraints {
            $0.top.equalTo(periodInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        introduceInputView.snp.makeConstraints {
            $0.top.equalTo(divisionInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

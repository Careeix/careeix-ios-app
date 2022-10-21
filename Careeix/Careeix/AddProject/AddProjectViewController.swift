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
import RxKeyboard

class AddProjectViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: AddProjectViewModel) {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.contentView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                owner.completeButtonView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                UIView.animate(withDuration: 0.4) {
                    owner.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
    
        titleInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollView.setContentOffset(.init(x: 0, y: owner.titleInputView.frame.minY), animated: true)
            }.disposed(by: disposeBag)
        
        divisionInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollView.setContentOffset(.init(x: 0, y: owner.periodInputView.frame.midY), animated: true)
            }.disposed(by: disposeBag)
        
        introduceInputView.textView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollView.setContentOffset(.init(x: 0, y: owner.periodInputView.frame.maxY), animated: true)
            }.disposed(by: disposeBag)
        
        periodInputView.startDateView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.didTapDateView(owner.startDatePickerView)
            }.disposed(by: disposeBag)
        
        periodInputView.endDateView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.didTapDateView(owner.endDatePickerView)
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                // TODO: - 화면전환
                print("다음 단계로 이동")
            }.disposed(by: disposeBag)
        
        startDatePickerCompleteButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.didTapDatePickerCompleteButtonView()
            }.disposed(by: disposeBag)
        
        startDatePicker.rx.date
            .map { $0.toString() }
            .asDriver(onErrorJustReturn: "")
            .drive(periodInputView.startDateView.contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        endDatePicker.rx.date
            .map { $0.toString() }
            .asDriver(onErrorJustReturn: "")
            .drive(periodInputView.endDateView.contentLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - function
    func didTapDatePickerCompleteButtonView() {
        startDatePickerView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(270)
        }

        endDatePickerView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(270)
        }
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    func didTapDateView(_ sender: UIView) {
        view.endEditing(true)
        scrollView.contentOffset.y = titleInputView.frame.minX
        sender.isHidden = false
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(250)
        }
        sender.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Initializer
    init(viewModel: AddProjectViewModel) {
        titleInputView = .init(viewModel: viewModel.titleInputViewModel)
        periodInputView = .init(viewModel: viewModel.periodInputViewModel)
        divisionInputView = .init(viewModel: viewModel.divisionInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        completeButtonView = .init(viewModel: .init(content: "다음", backgroundColor: .disable))
        super.init(nibName: nil, bundle: nil)
        setUI()
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleInputView.textField.becomeFirstResponder()
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleInputView: SimpleInputView
    let periodInputView: PeriodInputView
    let divisionInputView: SimpleInputView
    let introduceInputView: ManyInputView
    let completeButtonView: CompleteButtonView
    let startDatePickerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.isHidden = true
        return v
    }()
    let startDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        
        return dp
    }()
    let startDatePickerCompleteButtonView: UIView = {
       let v = UIView()
        v.backgroundColor = .appColor(.error)
        return v
    }()
    let endDatePickerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.isHidden = true
        return v
    }()
    let endDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        return dp
    }()
    let endDatePickerCompleteButtonView: UIView = {
       let v = UIView()
        v.backgroundColor = .appColor(.error)
        return v
    }()

}

extension AddProjectViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [titleInputView, periodInputView, divisionInputView, introduceInputView].forEach { contentView.addSubview($0) }
        
        titleInputView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        periodInputView.snp.makeConstraints {
            $0.top.equalTo(titleInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        divisionInputView.snp.makeConstraints {
            $0.top.equalTo(periodInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        introduceInputView.snp.makeConstraints {
            $0.top.equalTo(divisionInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(90)
        }
        
        view.addSubview(completeButtonView)
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(78)
            $0.bottom.equalToSuperview()
        }
        
        view.addSubview(startDatePickerView)
        startDatePickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(270)
            
        }

        startDatePickerView.addSubview(startDatePicker)
        startDatePickerView.addSubview(startDatePickerCompleteButtonView)
            
        
        startDatePickerCompleteButtonView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        startDatePicker.snp.makeConstraints {
            $0.top.equalTo(startDatePickerCompleteButtonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        
        view.addSubview(endDatePickerView)
        endDatePickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(270)

        }

        endDatePickerView.addSubview(endDatePicker)
        endDatePickerView.addSubview(endDatePickerCompleteButtonView)

        endDatePicker.snp.makeConstraints {
            $0.top.equalTo(endDatePickerCompleteButtonView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
}

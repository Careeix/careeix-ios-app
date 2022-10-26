//
//  ProjectInputViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift
import RxKeyboard

class ProjectInputViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    let viewModel: ProjectInputViewModel
    
    let datePickerViewHeight: CGFloat = DatePickerView.datePickerHeight + DatePickerView.datePickerTopViewHeight
    lazy var datePickerOffset: CGFloat = datePickerViewHeight + DatePickerView.datePickerShadowHeight * 10
    // MARK: - Binding
    func bind(to viewModel: ProjectInputViewModel) {
        
        viewModel.nextButtonEnableDriver
            .drive(with: self) { owner, _ in
                owner.completeButtonView.backgroundColor = .appColor(.next)
                owner.completeButtonView.isUserInteractionEnabled = true
            }.disposed(by: disposeBag)
        
        viewModel.nextButtonDisableDriver
            .drive(with: self) { owner, _ in
                owner.completeButtonView.backgroundColor = .appColor(.disable)
                owner.completeButtonView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)
        
        viewModel.showNextViewDriver
            .drive(with: self) { owner, _ in
                // TODO: -
                print("입력값: ", UserDefaultManager.shared.projectInput)
//                 = inputs
                owner.view.endEditing(true)
                owner.navigationController?.pushViewController(ProjectInputDetailViewController.init(viewModel: .init()), animated: true)
            }.disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                print(keyboardVisibleHeight)
                owner.contentView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                owner.completeButtonView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                if keyboardVisibleHeight != 0 {
                    owner.hideBottomUpView(owner.startDatePickerView)
                    owner.hideBottomUpView(owner.endDatePickerView)
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
                owner.hideBottomUpView(owner.endDatePickerView)
                owner.showBottomUpView(owner.startDatePickerView)
            }.disposed(by: disposeBag)
        
        periodInputView.endDateView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.hideBottomUpView(owner.startDatePickerView)
                owner.showBottomUpView(owner.endDatePickerView)
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in true }
            .bind(to: viewModel.viewWillDisappearWithIsWritingRelay)
            .disposed(by: disposeBag)
        
        startDatePickerView.datePickerTopViewRightLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.hideBottomUpView(owner.startDatePickerView)
            }.disposed(by: disposeBag)
        
        endDatePickerView.datePickerTopViewRightLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.hideBottomUpView(owner.endDatePickerView)
            }.disposed(by: disposeBag)
        
        startDatePickerView.datePicker.rx.date
            .map { $0.toString() }
            .bind(to: viewModel.periodInputViewModel.startDateViewModel.inputStringRelay)
            .disposed(by: disposeBag)
        
        endDatePickerView.datePicker.rx.date
            .map { $0.toString() }
            .bind(to: viewModel.periodInputViewModel.endDateViewModel.inputStringRelay)
            .disposed(by: disposeBag)
        
        viewModel.popViewControllerDriver
            .debug("popViewControllerDriver")
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
//        viewModel.startDateStringDriver
//            .drive(periodInputView.startDateView.contentLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel.endDateStringDriver
//            .drive(periodInputView.endDateView.contentLabel.rx.text)
//            .disposed(by: disposeBag)
    }
    
    // MARK: - function
    override func didTapBackButton() {
        showWarningCancelWritingAlertView()
    }
    
    func showAskingKeepWritingView() {
        let askingKeepWritingView = TwoButtonAlertViewController(viewModel: .init(type: .askingKeepWriting))
        askingKeepWritingView.delegate = self
        present(askingKeepWritingView, animated: true)
    }
    
    func showWarningCancelWritingAlertView() {
        let warningCancelWritingAlertView = TwoButtonAlertViewController(viewModel: .init(type: .wraningCancelWriting))
        warningCancelWritingAlertView.delegate = self
        
        present(warningCancelWritingAlertView, animated: true)
        
    }
    
    func hideBottomUpView(_ sender: UIView) {
        sender.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(datePickerOffset)
        }
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func showBottomUpView(_ sender: UIView) {
        view.endEditing(true)
        sender.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(datePickerViewHeight)
        }
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectInputViewModel) {
        self.viewModel = viewModel
        titleInputView = .init(viewModel: viewModel.titleInputViewModel)
        periodInputView = .init(viewModel: viewModel.periodInputViewModel)
        divisionInputView = .init(viewModel: viewModel.divisionInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        completeButtonView = .init(viewModel: .init(content: "다음", backgroundColor: .disable))
        super.init(nibName: nil, bundle: nil)
        periodInputView.delegate = self
        setUI()
        bind(to: viewModel)
        configureNavigationBar()
        view.backgroundColor = .appColor(.white)
        
        completeButtonView.isUserInteractionEnabled = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UserDefaultManager.shared.projectInput = .init(title: "a", division: "ㅠ", indroduce: "ㅊ")
//        print("asds", UserDefaultManager.shared.projectInput.checkRemain())
//        print("Asd", UserDefaultManager.shared.projectInput)
        if !UserDefaultManager.shared.isWritingProject &&
            viewModel.checkRemainingData() {
            showAskingKeepWritingView()
        }
        // TODO: 주석 풀기
        UserDefaultManager.shared.isWritingProject = true
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
    let startDatePickerView = DatePickerView(viewModel: .init(title: "시작 날짜"))
    let endDatePickerView = DatePickerView(viewModel: .init(title: "종료 날짜"))
}

extension ProjectInputViewController {
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
            $0.bottom.equalToSuperview().offset(datePickerOffset)
        }
        
        view.addSubview(endDatePickerView)
        
        endDatePickerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(datePickerOffset)
        }
        
    }
}

extension ProjectInputViewController: PeriodInputViewDelegate {
    func didTapProceedingCheckBox(isProceed: Bool) {
        viewModel.periodInputViewModel.endDateViewModel.inputStringRelay.accept(Date().toString())
        endDatePickerView.datePicker.setDate(Date(), animated: false)
        hideBottomUpView(endDatePickerView)
        
        UserDefaultManager.shared.projectInput.isProceed = isProceed
    }
}

extension ProjectInputViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        switch type {
        case .askingKeepWriting:
            viewModel.fillRemainingInput()
        case .wraningCancelWriting:
            viewModel.viewWillDisappearWithIsWritingRelay.accept(false)
        default:
            break
        }
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        switch type {
        case .askingKeepWriting:
            UserDefaultManager.shared.projectInput = .init(title: "", division: "", indroduce: "")
            UserDefaultManager.shared.projectChapters = []
        default:
            break
        }
        
    }
}

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
                owner.updateCompleteButtonView(with: true)
            }.disposed(by: disposeBag)

        viewModel.nextButtonDisableDriver
            .drive(with: self) { owner, _ in
                owner.updateCompleteButtonView(with: false)
            }.disposed(by: disposeBag)
        
        viewModel.combinedDataDriver
            .drive { data in
                viewModel.updatePersistanceData(data)
            }.disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)

        titleInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollTo(y: owner.titleInputView.frame.minY)
            }.disposed(by: disposeBag)
        
        classificationInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollTo(y: owner.periodInputView.frame.midY)
            }.disposed(by: disposeBag)
        
        introduceInputView.textView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.scrollTo(y: owner.periodInputView.frame.maxY)
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
            .withUnretained(self)
            .bind { owner, _ in
                owner.showNextViewController()
            }.disposed(by: disposeBag)
        
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
        
        viewModel.checkBoxIsSelctedDriver
            .drive(with: self) { owner, isSelected in
                owner.updatePeriodView(isProceed: isSelected)
            }.disposed(by: disposeBag)
        
        viewModel.askingKeepAlertDriver
            .drive(with: self) { owner, _ in
                owner.showAskingKeepWritingView()
            }.disposed(by: disposeBag)
        
        viewModel.fillDataDriver
            .drive { _ in
                viewModel.fillRemainingInput()
            }.disposed(by: disposeBag)
    }
    
    // MARK: - function
    func scrollTo(y: CGFloat) {
        scrollView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
    
    func updateCompleteButtonView(with state: Bool) {
        completeButtonView.backgroundColor = .appColor(state ? .next : .disable)
        completeButtonView.isUserInteractionEnabled = state
    }
    
    func updatePeriodView(isProceed: Bool) {
        viewModel.periodInputViewModel.endDateViewModel.inputStringRelay.accept(Date().toString())
        endDatePickerView.datePicker.setDate(Date(), animated: false)
        hideBottomUpView(endDatePickerView)
    }
    
    override func didTapBackButton() {
        viewModel.checkRemainingData()
        ? showWarningCancelWritingAlertView()
        : popViewController()
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showNextViewController() {
        view.endEditing(true)
        navigationController?.pushViewController(ProjectInputDetailViewController.init(viewModel: .init()), animated: true)
    }
    
    func showAskingKeepWritingView() {
        let askingKeepWritingView = TwoButtonAlertViewController(viewModel: .init(type: .askingKeepWriting))
        askingKeepWritingView.delegate = self
        present(askingKeepWritingView, animated: true)
    }
    
    func showWarningCancelWritingAlertView() {
        let warningCancelWritingAlertView = TwoButtonAlertViewController(viewModel: .init(type: .warningCancelWriting))
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
    
    func updateView(with keyboardHeight: CGFloat) {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        completeButtonView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        if keyboardHeight != 0 {
            hideBottomUpView(startDatePickerView)
            hideBottomUpView(endDatePickerView)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectInputViewModel) {
        self.viewModel = viewModel
        titleInputView = .init(viewModel: viewModel.titleInputViewModel)
        periodInputView = .init(viewModel: viewModel.periodInputViewModel)
        classificationInputView = .init(viewModel: viewModel.classificationInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        completeButtonView = .init(viewModel: .init(content: "다음", backgroundColor: .disable))
        super.init(nibName: nil, bundle: nil)
        introduceInputView.textView.delegate = self
        bind(to: viewModel)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupNavigationBackButton()
        view.backgroundColor = .appColor(.white)
        viewModel.initProject()
        NotificationCenter.default.addObserver(self, selector: #selector(occurNetworkError), name: Notification.Name(rawValue: "projectFetchError"), object: nil)
        updateCompleteButtonView(with: false)
    }
    
    @objc
    func occurNetworkError() {
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navigationController = navigationController as? NavigationController {
            navigationController.updateProgressBar(progress: 1 / 3.0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewDidAppearRelay.accept(())
        titleInputView.textField.becomeFirstResponder()
        
    }
    
    deinit {
        viewModel.deinitVC()
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleInputView: SimpleInputView
    let periodInputView: PeriodInputView
    let classificationInputView: SimpleInputView
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
        
        [titleInputView, periodInputView, classificationInputView, introduceInputView].forEach { contentView.addSubview($0) }
        
        titleInputView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        periodInputView.snp.makeConstraints {
            $0.top.equalTo(titleInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        classificationInputView.snp.makeConstraints {
            $0.top.equalTo(periodInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        introduceInputView.snp.makeConstraints {
            $0.top.equalTo(classificationInputView.snp.bottom).offset(40)
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

extension ProjectInputViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        switch type {
        case .askingKeepWriting:
            viewModel.fillRemainingInput()
        case .warningCancelWriting:
            popViewController()
        default:
            break
        }
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        switch type {
        case .askingKeepWriting:
            viewModel.initPersistenceData()
            
        default:
            break
        }
        
    }
}

extension ProjectInputViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text else { return false }
        if text.contains("\n") {
            textView.text = text.replacingOccurrences(of: "\n", with: "")
        }
        return text.count < 55 || range.length == 1
    }
}

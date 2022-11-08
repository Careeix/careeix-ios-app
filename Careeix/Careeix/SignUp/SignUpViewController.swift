//
//  SignUpViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxGesture

class SignUpViewController: UIViewController {
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: SignUpViewModel) {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.createUserTrigger)
            .disposed(by: disposeBag)
        
        viewModel.completeButtonDisableDriver
            .drive(with: self) { owner, _ in
                owner.updateCompleteButtonView(with: false)
            }.disposed(by: disposeBag)
        
        viewModel.completeButtonEnableDriver
            .drive(with: self) { owner, _ in
                owner.updateCompleteButtonView(with: true)
            }.disposed(by: disposeBag)
        
        viewModel.showTabbarCotrollerDriver
            .drive(with: self) { owner, _ in
                NotificationCenter.default.post(name: Notification.Name("loginSuccess"), object: nil)
            }.disposed(by: disposeBag)
        
        nickNameInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .map { owner, _ in (owner, owner.titleLabel.frame.minY - 10) }
            .bind { owner, y in
                owner.scrollTo(y: y)
            }.disposed(by: disposeBag)
        
        jobInputView.textField.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .map { owner, _ in (owner, owner.nickNameInputView.frame.maxY) }
            .bind { owner, y in
                owner.scrollTo(y: y)
            }.disposed(by: disposeBag)
        
        detailJobTagInputView.tableView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .map { owner, _ in (owner, owner.detailJobTagInputView.frame.minY - 50) }
            .bind { owner, y in
                owner.scrollTo(y: y)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Function
    
    func updateView(with keyboardHeight: CGFloat) {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        completeButtonView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(
                keyboardHeight == 0
                ? 50
                :keyboardHeight + 26
            )
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateCompleteButtonView(with state: Bool) {
        completeButtonView.backgroundColor = .appColor(state ? .main : .disable)
        completeButtonView.isUserInteractionEnabled = state
    }
    
    func scrollTo(y: CGFloat) {
        scrollView.setContentOffset(.init(x: 0, y: y), animated: true)
    }
    
    // MARK: - Life Cycle
    init(viewModel: SignUpViewModel) {
        nickNameInputView = SimpleInputView(viewModel: viewModel.nickNameInputViewModel)
        jobInputView = SimpleInputView(viewModel: viewModel.jobInputViewModel)
        annualInputView = RadioInputView(viewModel: viewModel.annualInputViewModel)
        detailJobTagInputView = MultiInputView(viewModel: viewModel.detailJobsInputViewModel)
        completeButtonView = {
            let v = CompleteButtonView(viewModel: viewModel.completeButtonViewModel)
            v.layer.cornerRadius = 10
            v.backgroundColor = .appColor(.disable)
            return v
        }()
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        annualInputView.delegate = self
        view.backgroundColor = .white
        
        setupNavigationBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nickNameInputView.textField.becomeFirstResponder()
    }

    
    // MARK: - UIComponents
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    let contentView = UIView()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "추가 정보를 입력해주세요"
        l.font = .pretendardFont(size: 24, style: .bold)
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "회원가입 후 수정 가능합니다"
        l.font = .pretendardFont(size: 13, style: .regular)
        l.textColor = .appColor(.gray400)
        return l
    }()
    let nicknameCheckLabel: UILabel = {
        let l = UILabel()
        l.text = "*중복된 닉네임입니다."
        l.font = .pretendardFont(size: 10, style: .regular)
        l.textColor = .appColor(.error)
        l.isHidden = true
        l.textColor = .appColor(.error)
        return l
    }()
    let nickNameInputView:SimpleInputView
    let jobInputView:SimpleInputView
    let annualInputView:RadioInputView
    let detailJobTagInputView:MultiInputView
    let completeButtonView: CompleteButtonView
    
}

extension SignUpViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        [titleLabel, descriptionLabel, nickNameInputView, nicknameCheckLabel, jobInputView, annualInputView, detailJobTagInputView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        nickNameInputView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        nicknameCheckLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameInputView.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        
        jobInputView.snp.makeConstraints {
            $0.top.equalTo(nicknameCheckLabel.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        annualInputView.snp.makeConstraints {
            $0.top.equalTo(jobInputView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        detailJobTagInputView.snp.makeConstraints {
            $0.top.equalTo(annualInputView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(161)
        }

        view.addSubview(completeButtonView)
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
}

extension SignUpViewController: EventDelegate {
    func didTapRadioInputView() {
        scrollView.setContentOffset(.init(x: 0, y: annualInputView.frame.minY - 50), animated: true)
    }
}

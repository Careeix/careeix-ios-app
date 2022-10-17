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
    let viewModel = SignUpViewModel(
        nickNameInputViewModel: .init(title: "닉네임",
                                      placeholder: "10자 이내로 한글, 영문, 숫자를 입력해주세요."),
        jobInputViewModel: .init(title: "직무",
                                 placeholder: "직무를 입력해주세요.(Ex. 서버 개발자)"),
        annualInputViewModel: .init(title: "연차",
                                    contents: ["입문(1년 미만)",
                                               "주니어(1~4년차)",
                                               "미들(5~8년차)",
                                               "시니어(9년차~)"]),
        detailJobsInputViewModel: .init(title: "상세 직무",
                                        placeholders: Array(repeating: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)",
                                                            count: 3)),
        completeButtonViewModel: .init(content: "회원가입", backgroundColor: .signatureDark)
    )
    
    // MARK: - Binding
    func bind() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive { [weak self] keyboardVisibleHeight in
                self?.contentView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
            }
            .disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.createUserTrigger)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUI()
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "추가 정보를 입력해주세요"
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "회원가입 후 수정 가능합니다"
        return l
    }()
    let nicknameCheckLabel: UILabel = {
        let l = UILabel()
        l.text = "*중복된 닉네임입니다."
        l.textColor = .appColor(.error)
        return l
    }()
    lazy var nickNameInputView = SimpleInputView(viewModel: viewModel.nickNameInputViewModel)
    lazy var jobInputView = SimpleInputView(viewModel: viewModel.jobInputViewModel)
    lazy var annualInputView = RadioInputView(viewModel: viewModel.annualInputViewModel)
    lazy var detailJobTagInputView = MultiInputView(viewModel: viewModel.detailJobsInputViewModel)
    lazy var completeButtonView = CompleteButtonView(viewModel: viewModel.completeButtonViewModel)
}

extension SignUpViewController {
    func setUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [titleLabel, descriptionLabel, nickNameInputView, nicknameCheckLabel, jobInputView, annualInputView, detailJobTagInputView, completeButtonView].forEach { contentView.addSubview($0) }
        
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
        }
        
        completeButtonView.snp.makeConstraints {
            $0.top.equalTo(detailJobTagInputView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview()
        }
    }
}

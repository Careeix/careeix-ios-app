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

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SignUpViewModel(nickNameInputViewModel: .init(title: "닉네임",
                                                                  placeholder: "10자 이내로 한글, 영문, 숫자를 입력해주세요."),
                                    jobInputViewModel: .init(title: "직무",
                                                             placeholder: "직무를 입력해주세요.(Ex. 서버 개발자)"),
                                    annualInputViewModel: .init(title: "연차",
                                                                contents: ["입문(1년 미만)",
                                                                           "주니어(1~4년차)",
                                                                           "미들(5~8년차)",
                                                                           "시니어(9년차~)"]),
                                    detailJobInputViewModel: .init(title: "상세 직무",
                                                                   placeholders: Array(repeating: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)", count: 3)),
                                    completeButtonViewModel: .init(content: "회원가입", backgroundColor: .signatureDark)
    )
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    lazy var nickNameInputView = BaseInputView(viewModel: viewModel.nickNameInputViewModel)
    lazy var jobInputView = BaseInputView(viewModel: viewModel.jobInputViewModel)
    lazy var annualInputView = RadioInputView(viewModel: viewModel.annualInputViewModel)
    lazy var tempView: UIView = {
       let v = UIView()
        v.backgroundColor = .orange
        return v
    }()
//    lazy var detailJobTagInputView = MultiInputView(viewModel: viewModel.detailJobInputViewModel)
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
        
        [titleLabel, descriptionLabel, nickNameInputView, nicknameCheckLabel, jobInputView, annualInputView, tempView].forEach { contentView.addSubview($0) }
        
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
            $0.height.lessThanOrEqualTo(1000)
//            $0.bottom.equalToSuperview()
        }
        tempView.snp.makeConstraints {
            $0.top.equalTo(annualInputView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(500)
        }
//        detailJobTagInputView.snp.makeConstraints {
//            $0.top.equalTo(annualInputView.snp.bottom).offset(50)
//            $0.leading.trailing.equalToSuperview().inset(16)
//            $0.bottom.equalToSuperview()
//        }
        
//        completeButtonView.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(56)
//        }
    }
}

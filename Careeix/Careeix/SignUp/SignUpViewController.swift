//
//  SignUpViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import SnapKit


class SignUpViewController: UIViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
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
    let nickNameInputView = BaseInputView(title: "닉네임", placeholder: "10자 이내로 한글, 영문, 숫자를 입력해주세요.")
    let jobInputView = BaseInputView(title: "직무", placeholder: "직무를 입력해주세요.(Ex. 서버 개발자)")
    let annualInputView = RadioInputView()
    let detailJobTagInputView = MultiInputView()
    let completeButtonView = CompleteButtonView(content: "회원가입", backgroundColor: .appColor(.signatureDark))
}

extension SignUpViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        [titleLabel, descriptionLabel, nickNameInputView, nicknameCheckLabel, jobInputView, annualInputView, detailJobTagInputView, completeButtonView].forEach { scrollView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(14)
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
            $0.bottom.equalToSuperview()
        }
        
        completeButtonView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}

//
//  UpdatedMyProfileViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/07.
//

import Foundation
import UIKit
import SnapKit

class UpdatedMyProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        setupNavigationBackButton()
        hidesBottomBarWhenPushed = true
    }
    
    let scrollView = UIScrollView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "커리어 프로필 수정"
        label.textColor = .appColor(.black)
        label.font = .pretendardFont(size: 22, style: .semiBold)
        return label
    }()
    
    let userJobTextField = SimpleInputView(viewModel: .init(title: "직무", textFieldViewModel: .init(placeholder: "직무를 입력해주세요.")))
    let userWorkTextField = RadioInputView(viewModel: .init(title: "연차", contents: ["입문(1년 미만)", "주니어(1~4년차)", "미들(5~8년차)", "시니어(9년차~)"]))
    let userDetailJobsTextField = MultiInputView(viewModel: .init(title: "상세 직무 태그", description: "상세 직무 태그는 1~3개까지 입력 가능합니다.", textFieldViewModels: [.init(placeholder: "상세 직무 태그를 입력해주세요.(Ex. UX 디자인)")]))
    let userIntroduceTextField = ManyInputView(viewModel: .init(title: "소개", baseTextViewModel: .init(placeholder: "소개글을 작성해주세요.")))
    
    func setScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setUI() {
        [titleLabel, userJobTextField, userWorkTextField, userDetailJobsTextField, userIntroduceTextField].forEach { scrollView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(58)
            $0.leading.equalToSuperview().offset(24)
        }
        
        userJobTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(39)
            $0.leading.equalToSuperview().offset(20)
        }
        
        userWorkTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.leading.equalTo(userJobTextField.snp.leading)
        }
        
        userDetailJobsTextField.snp.makeConstraints {
            $0.top.equalTo(userWorkTextField.snp.bottom).offset(50)
            $0.leading.equalTo(userWorkTextField.snp.leading)
        }
        
        userIntroduceTextField.snp.makeConstraints {
            $0.top.equalTo(userDetailJobsTextField.snp.bottom).offset(50)
            $0.leading.equalTo(userDetailJobsTextField.snp.leading)
        }
    }
}

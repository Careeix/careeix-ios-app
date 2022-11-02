//
//  UpdatedNicknameViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit

class UpdatedNicknameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBackButton()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}

extension UpdatedNicknameViewController {
    func setUI() {
        let textFieldView = SimpleInputView(viewModel: .init(title: "닉네임 변경", textFieldViewModel: .init(placeholder: "2자 ~ 10자 이내로 한글, 영어 및 숫자를 포함하여 입력해주세요")))
        let confirmButton = CompleteButtonView(viewModel: .init(content: "완료", backgroundColor: .main))
        confirmButton.layer.cornerRadius = 10
        
        [textFieldView, confirmButton].forEach { view.addSubview($0) }
        
        textFieldView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(106)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(43)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}

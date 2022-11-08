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
    let textFieldView = SimpleInputView(viewModel: .init(title: "닉네임 변경", textFieldViewModel: .init(placeholder: "2자 ~ 10자 이내로 한글, 영어 및 숫자를 포함하여 입력해주세요")))
    let confirmButton = CompleteButtonView(viewModel: .init(content: "완료", backgroundColor: .disable))
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBackButton()
        setUI()
        tapConfirmButton()
        view.backgroundColor = .appColor(.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFieldView.textField.becomeFirstResponder()
    }
    
    func tapConfirmButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchedConfirmButton))
        confirmButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func touchedConfirmButton() {
        print("nickName Value: \(textFieldView.textField.text!)")
        navigationController?.popViewController(animated: true)
        updateUserData()
        dismiss(animated: true)
    }
    
    func updateUserData() {
        guard let userNickName = self.textFieldView.textField.text else { return }
        API<UserDataUpdateModel>(path: "users/update-profile", method: .post, parameters: ["userNickname": userNickName], task: .requestJSONEncodable(userNickName), headers: ["X-ACCESS-TOKEN": UserDefaultManager.user.jwt]).request { result in
            print("result: \(result)")
            switch result {
            case .success(let response):
                // data:
                print("😀😀😀😀유저닉네임 업데이트: \(response.code), \(response.message)😀😀😀😀")
                print(response.data!)
            case .failure(let error):
                // alert
                print("😀😀😀😀유저닉네임 업데이트 실패: \(error.localizedDescription)😀😀😀😀")
            }
        }
    }
}

extension UpdatedNicknameViewController {
    func setUI() {
        confirmButton.layer.cornerRadius = 10
        
        [textFieldView, confirmButton].forEach { view.addSubview($0) }
        
        textFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(106)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(43)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}

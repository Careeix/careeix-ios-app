//
//  UpdatedNicknameViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit
import RxKeyboard
import RxSwift
import Moya

class UpdatedNicknameViewController: UIViewController {
    var disposeBag = DisposeBag()
    let textFieldView = SimpleInputView(viewModel: .init(title: "닉네임 변경", textFieldViewModel: .init(placeholder: "2자 ~ 10자 이내로 한글, 영어 및 숫자를 포함하여 입력해주세요")))
    let confirmButton = CompleteButtonView(viewModel: .init(content: "완료", backgroundColor: .disable))
    let sameNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "*기존 닉네임과 동일합니다."
        label.textColor = .appColor(.error)
        label.font = .pretendardFont(size: 10, style: .regular)
        return label
    }()
    
    let subject = PublishSubject<Bool>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBackButton()
        setUI()
        tapConfirmButton()
        view.backgroundColor = .appColor(.white)
        keyboardBinding()

        textFieldView.textField.text = UserDefaultManager.user.userNickname
        let inputText = textFieldView.textField.rx.text.orEmpty.share()
        
        inputText
            .map { $0 != "" }
            .bind(to: subject)
            .disposed(by: disposeBag)
        
        inputText
            .debug("😩")
            .map { $0 == UserDefaultManager.user.userNickname }
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isSame in
                owner.sameNicknameLabel.isHidden = !isSame
                owner.confirmButton.backgroundColor = !isSame ? .appColor(.main) : .appColor(.disable)
                owner.confirmButton.isUserInteractionEnabled = !isSame
            }.disposed(by: disposeBag)
        
        subject.asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isEnable in
                owner.confirmButton.backgroundColor = isEnable ? .appColor(.main) : .appColor(.disable)
                owner.confirmButton.isUserInteractionEnabled = isEnable
            }.disposed(by: disposeBag)
        
    }
    
    func keyboardBinding() {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.confirmButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(
                        keyboardVisibleHeight == 0
                        ? 50
                        :keyboardVisibleHeight + 26
                    )
                }
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
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
    }
    
    func updateUserData() {
        guard let userNickname = self.textFieldView.textField.text else { return }
        API<UpdateUserNicknameModel>(path: "users/update-profile-nickname", method: .post, parameters: ["userNickname": userNickname], task: .requestParameters(encoding: URLEncoding(destination: .queryString))).request { result in
            print(result)
            switch result {
            case .success(let response):
                // data:
//                UserDefaultManager.user.userNickname = response.data!.userNickname
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
        
        [textFieldView, sameNicknameLabel, confirmButton].forEach { view.addSubview($0) }
        
        textFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(106)
        }
        
        sameNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(24)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(43)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
    }
}

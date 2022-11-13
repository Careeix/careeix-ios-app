//
//  AccountInfoViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit
import PhotosUI
enum UserSocialProvider: String {
    case kakao = "카카오 로그인"
    case apple = "애플 로그인"
    
    func imageName() -> String {
        switch self {
        case .kakao:
            return "smallKakao"
        case .apple:
            return "smallApple"
        }
    }
}

class AccountInfoViewController: UIViewController {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 정보"
        label.textColor = .appColor(.gray900)
        label.font = .pretendardFont(size: 18, style: .medium)
        return label
    }()
    
    let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let kindOfLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray400)
        label.font = .pretendardFont(size: 15, style: .regular)
        return label
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 관리"
        label.textColor = .appColor(.gray900)
        label.font = .pretendardFont(size: 18, style: .medium)
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "basicProfile")
        imageView.layer.cornerRadius = 89 / 2
        return imageView
    }()
    
    let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "halfBlackCamera")
        return imageView
    }()
    
    let nickNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 변경"
        label.textColor = .appColor(.gray900)
        label.font = .pretendardFont(size: 15, style: .light)
        return label
    }()
    
    let nickNameButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray900)
        label.font = .pretendardFont(size: 15, style: .medium)
        label.text = "삐용"
        return label
    }()
    
    let rightButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right")
        return imageView
    }()
    
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 15, style: .medium)
        button.setTitleColor(.appColor(.gray300), for: .normal)
        return button
    }()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBackButton()
        setUI()
        tapNickNameButton()
        tapFilterImageView()
        filterImageView.isUserInteractionEnabled = true
        view.backgroundColor = .appColor(.white)
        withdrawalButton.addTarget(self, action: #selector(didTapWithDrawButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        getUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc
    func didTapWithDrawButton() {
        let vc = TwoButtonAlertViewController(viewModel: .init(type: .warningSecession))
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func openImageLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func tapNickNameButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToUpdatedNickNameVC))
        nickNameButtonView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func moveToUpdatedNickNameVC() {
        //        let updatedNicknameVC = UpdatedNicknameViewController()
        //        self.navigationController?.pushViewController(updatedNicknameVC, animated: true)
        print("😏😏😏😏updatedNickNameView Clicked!!")
    }
    
    func tapFilterImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFilterImageView))
        filterImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func moveToUpdatedNickNameVC() {
        let updatedNicknameVC = UpdatedNicknameViewController()
        self.navigationController?.pushViewController(updatedNicknameVC, animated: true)
        print("😏😏😏😏updatedNickNameView Clicked!!")
    }
   
    @objc func didTapFilterImageView() {
        //        activeActionSheet()
        print("🐿🐿🐿didTapFilterImageView clicked!!!")
    }
    
    //MARK: Action WithdrawalButton
    
    func actionWithdrawalButton() {
        withdrawalButton.addTarget(self, action: #selector(didTapWithdrawalButton), for: .touchUpInside)
    }
    
    @objc func didTapWithdrawalButton() {
        print("🥽🥽🥽회원탈퇴 버튼 눌림🥽🥽🥽")
    }
    
    //MARK: GetUserData - UserDefaultManager
    
    func getUserData() {
        let user = UserDefaultManager.user
        let socialProvider = user.userSocialProvider
        let type: UserSocialProvider = socialProvider == 0 ? .kakao : .apple
        kindOfLoginLabel.text = type.rawValue
        loginImageView.image = UIImage(named: type.imageName())
        nickNameLabel.text = user.userNickname
    }
    
    // MARK: NetWorking - UserProfileImage
    
    func updateUserProfileImage() {
        API<UpdateUserProfileImageModel>(path: "update-profile-file", method: .post, parameters: [:], task: .requestPlain).request { result in
            switch result {
            case .success(let response):
                print(response.data!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Updated ProfileImage ActionSheet
    
    func activeActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 이미지 관리", message: nil, preferredStyle: .actionSheet)
        let updateImageAction = UIAlertAction(title: "프로필 이미지 변경", style: .default) { action in
            print("🪢🪢updateImageAction clicked!!!")
            self.openImageLibrary()
        }
        let deleteImageAction = UIAlertAction(title: "프로필 이미지 삭제", style: .destructive) { action in
            print("🧶🧶deleteImageAction clicked!!!")
            self.profileImageView.image = UIImage(named: "basicProfile")
            let deleteImageAlert = OneButtonAlertViewController(viewModel: .init(content: "프로필 이미지가 삭제되었습니다.", buttonText: "확인", textColor: .gray400))
            self.present(deleteImageAlert, animated: true)
        }
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [updateImageAction, deleteImageAction, actionCancel].forEach { actionSheet.addAction($0) }
        
        self.present(actionSheet, animated: true)
    }
    
    //MARK: Open PhotoAlbum
    
    func openImageLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
}

extension AccountInfoViewController: PHPickerViewControllerDelegate {
    
    //MARK: PHPickerViewControllerDelegate

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.profileImageView.image = image as? UIImage
                    self.profileImageView.layer.masksToBounds = true
                }
            }
        } else {
            print("이미지 바꾸기 실패!!!")
        }
        let updateImageAlert = OneButtonAlertViewController(viewModel: .init(content: "프로필 이미지가 변경되었습니다.", buttonText: "확인", textColor: .gray400))
        present(updateImageAlert, animated: true)
    }
}

extension AccountInfoViewController {
    
    //MARK: SetUI
    
    func setUI() {
        [nickNameLabel, rightButtonImageView].forEach { nickNameButtonView.addSubview($0) }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightButtonImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
        
        [infoLabel, loginImageView, kindOfLoginLabel, profileLabel, profileImageView, filterImageView, nickNameTitleLabel, nickNameButtonView, withdrawalButton]
            .forEach { view.addSubview($0) }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(106)
            $0.leading.equalToSuperview().offset(20)
        }
        
        loginImageView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(21.64)
            $0.leading.equalToSuperview().offset(29.47)
            $0.width.height.equalTo(37)
        }
        
        kindOfLoginLabel.snp.makeConstraints {
            $0.leading.equalTo(loginImageView.snp.trailing).offset(11.82)
            $0.top.equalTo(infoLabel.snp.bottom).offset(28)
        }
        
        profileLabel.snp.makeConstraints {
            $0.top.equalTo(loginImageView.snp.bottom).offset(75.64)
            $0.leading.equalTo(infoLabel.snp.leading)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(profileLabel.snp.bottom).offset(30)
            $0.width.height.equalTo(85)
            $0.leading.equalToSuperview().offset(30)
        }
        
        filterImageView.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
        
        nickNameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(27)
        }
        
        nickNameButtonView.snp.makeConstraints {
            $0.top.equalTo(nickNameTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nickNameTitleLabel.snp.leading)
            $0.width.equalTo(335)
            $0.height.equalTo(45)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(45)
        }
    }
}

extension AccountInfoViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        
        API<ErrorResponse>(path: "users/withdraw", method: .post, parameters: [:], task: .requestPlain)
            .request { [weak self] result in
                switch result {
                case .success(_):
                    UserDefaultManager.firstLoginFlag = false
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logoutSuccess"), object: false)
                case .failure(let error):
                    if let error = error as? ErrorResponse {
                        let vc = OneButtonAlertViewController(viewModel: .init(content: error.message, buttonText: "확인", textColor: .error))
                        self?.present(vc, animated: true)
                    }
                }
            }
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
    }
}

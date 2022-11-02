//
//  AccountInfoViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit

class AccountInfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBackButton()
        setUI()
        print("view.frame.width: \(view.frame.width)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func moveToUpdatedNicknameVC() {
        let updatedNicknameVC = UpdatedNicknameViewController()
        self.navigationController?.pushViewController(updatedNicknameVC, animated: true)
    }
}

extension AccountInfoViewController {
    func setUI() {
        let infoLabel: UILabel = {
            let label = UILabel()
            label.text = "계정 정보"
            label.textColor = .appColor(.gray900)
            label.font = .pretendardFont(size: 18, style: .medium)
            return label
        }()
        
        let loginImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "smallKakao")
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let kindOfLoginLabel: UILabel = {
            let label = UILabel()
            label.textColor = .appColor(.gray400)
            label.font = .pretendardFont(size: 15, style: .regular)
            label.text = "카카오 로그인"
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
        
        let updatedNickNameButton: UIButton = {
            let button = UIButton()
            let rightMoveImageView = UIImage(named: "vector")
            button.setTitle("삐용", for: .normal)
            button.titleLabel?.font = .pretendardFont(size: 15, style: .medium)
            button.setTitleColor(.appColor(.gray900), for: .normal)
            button.setImage(rightMoveImageView, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.titleEdgeInsets.right = 290
            button.contentEdgeInsets.right = 10
            button.semanticContentAttribute = .forceRightToLeft
            button.contentHorizontalAlignment = .leading
            button.contentVerticalAlignment = .center
            return button
        }()
        
        let withdrawalButton: UIButton = {
            let button = UIButton()
            button.setTitle("회원탈퇴", for: .normal)
            button.titleLabel?.font = .pretendardFont(size: 15, style: .medium)
            button.setTitleColor(.appColor(.gray300), for: .normal)
            return button
        }()
        
        updatedNickNameButton.addTarget(self, action: #selector(moveToUpdatedNicknameVC), for: .touchUpInside)
        
        [infoLabel, loginImageView, kindOfLoginLabel, profileLabel, profileImageView, filterImageView, nickNameTitleLabel, updatedNickNameButton, withdrawalButton]
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
        
        updatedNickNameButton.snp.makeConstraints {
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

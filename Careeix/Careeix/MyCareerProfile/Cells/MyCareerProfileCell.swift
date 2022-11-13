//
//  MyCareerProfileCell.swift
//  Careeix
//
//  Created by mingmac on 2022/11/07.
//

import Foundation
import UIKit
import SnapKit

class MyCareerProfileCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        layoutIfNeeded()
        updateCareerProfileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapUpdateProfileImageView))
        updateCareerProfileImageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapUpdateProfileImageView() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didTapUpdateProfileImageView"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gradientView = UIView()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 89 / 2
        image.clipsToBounds = true
        return image
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray700)
        label.font = .pretendardFont(size: 20, style: .bold)
        return label
    }()
    
    let updateCareerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pencil")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let careerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 18.5, style: .extraBold)
        label.numberOfLines = 0
        return label
    }()
    
    let careerGradeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 14, style: .light)
        return label
    }()
    
    let firstDetailCareerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()

    let secondDetailCareerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()

    let thirdDetailCareerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()
    
    func configure(_ info: UserModel) {
        setProfileColor(fillColor: info.userProfileColor)
        setImageURL(url: info.userProfileImg ?? "")
        nickNameLabel.text = info.userNickname
        careerNameLabel.text = info.userJob
        careerGradeLabel.text = UserWork.setUserWork(grade: info.userWork)
        setUserDetailJobs(detailJobs: info.userDetailJobs)
        setProfileColor(fillColor: info.userProfileColor)
        
    }
    
    func setUserDetailJobs(detailJobs: [String]) {
        firstDetailCareerNameLabel.text = "#" + detailJobs[0]
        if detailJobs.count == 2 {
            firstDetailCareerNameLabel.text = "#" + detailJobs[0]
            secondDetailCareerNameLabel.text = "#" + detailJobs[1]
        } else {
            secondDetailCareerNameLabel.text = ""
        }
        if detailJobs.count == 3 {
            firstDetailCareerNameLabel.text = "#" + detailJobs[0]
            secondDetailCareerNameLabel.text = "#" + detailJobs[1]
            thirdDetailCareerNameLabel.text = "#" + detailJobs[2]
        } else {
            thirdDetailCareerNameLabel.text = ""
        }
    }
    
    func setImageURL(url: String) {
        let url = URL(string: url)
        if url == nil {
            profileImageView.image = UIImage(named: "basicProfile")
        } else {
            profileImageView.kf.setImage(with: url)
        }
    }
    
    func setProfileColor(fillColor: String) {
        GradientColor(rawValue: fillColor)?.setGradient(contentView: gradientView)

    }
    
    func setUI() {
        contentView.addSubview(gradientView)
       
        gradientView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [profileImageView, nickNameLabel, updateCareerProfileImageView, careerNameLabel, careerGradeLabel, firstDetailCareerNameLabel, secondDetailCareerNameLabel, thirdDetailCareerNameLabel]
            .forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(19)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(89)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13)
            $0.bottom.equalTo(gradientView.snp.top).offset(-5)
        }
        
        updateCareerProfileImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(nickNameLabel.snp.top)
        }
        
        careerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(22)
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
        }
        
        careerGradeLabel.snp.makeConstraints {
            $0.top.equalTo(careerNameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(22)
        }
        
        firstDetailCareerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(22)
            $0.top.equalTo(careerGradeLabel.snp.bottom).offset(25)
        }
        secondDetailCareerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(firstDetailCareerNameLabel.snp.trailing).offset(10)
            $0.top.equalTo(firstDetailCareerNameLabel.snp.top)
        }
        
        thirdDetailCareerNameLabel.snp.makeConstraints {
            $0.leading.equalTo(secondDetailCareerNameLabel.snp.trailing).offset(10)
            $0.top.equalTo(secondDetailCareerNameLabel.snp.top)
        }
    }
}

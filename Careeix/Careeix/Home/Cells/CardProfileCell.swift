//
//  CardProfileCell.swift
//  Careeix
//
//  Created by mingmac on 2022/10/21.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

enum UserWork: String {
    case starter = "입문(1년 미만)"
    case junior = "주니어(1~4년차)"
    case middle = "미들(5~8년차)"
    case senior = "시니어(9년차~)"
    
    static func setUserWork(grade: Int) -> String {
        switch grade {
        case 0:
            return UserWork.starter.rawValue
        case 1:
            return UserWork.junior.rawValue
        case 2:
            return UserWork.middle.rawValue
        case 3:
            return UserWork.senior.rawValue
        default :
            return UserWork.starter.rawValue
        }
    }
}

class CardProfileCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 89 / 2
        image.clipsToBounds = true
        return image
    }()
    
    let nickName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray700)
        label.font = .pretendardFont(size: 20, style: .bold)
        return label
    }()
    
    let careerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 18.5, style: .extraBold)
        label.numberOfLines = 0
        return label
    }()
    
    let careerGrade: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 14, style: .light)
        return label
    }()
    
    let firstDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()

    let secondDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()

    let thirdDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray30)
        label.font = .pretendardFont(size: 12, style: .light)
        return label
    }()
    
    func configure(_ info: UserModel) {
        setProfileColor(fillColor: info.userProfileColor)
        setImageURL(url: info.userProfileImg ?? "")
        nickName.text = info.userNickname
        careerName.text = info.userJob
        careerGrade.text = UserWork.setUserWork(grade: info.userWork)
        setUserDetailJobs(detailJobs: info.userDetailJobs)
        setUI()
    }
    
    func setUserDetailJobs(detailJobs: [String]) {
        firstDetailCareerName.text = "#" + detailJobs[0]
        if detailJobs.count == 2 {
            firstDetailCareerName.text = "#" + detailJobs[0]
            secondDetailCareerName.text = "#" + detailJobs[1]
        } else {
            secondDetailCareerName.text = ""
        }
        if detailJobs.count == 3 {
            firstDetailCareerName.text = "#" + detailJobs[0]
            secondDetailCareerName.text = "#" + detailJobs[1]
            thirdDetailCareerName.text = "#" + detailJobs[2]
        } else {
            thirdDetailCareerName.text = ""
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
        if GradientColor.skyblue.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.skyblueGradientSP), endColor: .appColor(.skyblueGradientEP), cornerRadius: 0)
        } else if GradientColor.yellow.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.yellowGradientSP), endColor: .appColor(.yellowGradientEP), cornerRadius: 0)
        } else if GradientColor.purple.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.purpleGradientSP), endColor: .appColor(.purpleGradientEP), cornerRadius: 0)
        } else if GradientColor.green.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.greenGradientSP), endColor: .appColor(.greenGradientEP), cornerRadius: 0)
        } else if GradientColor.pink.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.pinkGradientSP), endColor: .appColor(.pinkGradientEP), cornerRadius: 0)
        } else {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.orangeGradientSP), endColor: .appColor(.orangeGradientEP), cornerRadius: 0)
        }
    }
    
    func setUI() {
        [profileImageView, nickName, careerName, careerGrade, firstDetailCareerName, secondDetailCareerName, thirdDetailCareerName]
            .forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(19)
            $0.top.equalToSuperview().offset(-60)
            $0.width.height.equalTo(89)
        }
        
        nickName.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13)
            $0.top.equalToSuperview().offset(-30)
        }
        
        careerName.snp.makeConstraints {
            $0.leading.equalTo(22)
            $0.top.equalTo(profileImageView.snp.bottom).offset(14)
        }
        
        careerGrade.snp.makeConstraints {
            $0.top.equalTo(careerName.snp.bottom).offset(6)
            $0.leading.equalTo(22)
        }
        
        firstDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(22)
            $0.top.equalTo(careerGrade.snp.bottom).offset(25)
        }
        secondDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(firstDetailCareerName.snp.trailing).offset(10)
            $0.top.equalTo(firstDetailCareerName.snp.top)
        }
        
        thirdDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(secondDetailCareerName.snp.trailing).offset(10)
            $0.top.equalTo(secondDetailCareerName.snp.top)
        }
    }
}

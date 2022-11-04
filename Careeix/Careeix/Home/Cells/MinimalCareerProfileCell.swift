//
//  MinimalCareerProfile.swift
//  Careeix
//
//  Created by mingmac on 2022/10/14.
//

import Foundation
import SnapKit
import UIKit
import Kingfisher

/**
 2. 간편 커리어 프로필
    - Compositional Layout
        - cell 하나
    - Diffable Datasource
        - 뷰 안에 프로필 이미지, 닉네임, 직무, 연차, 상세 직무 태그
    - Snapshot
*/

enum GradientColor: String {
    case skyblue = "#8DB8DF"
    case pink = "#E9A6C6"
    case yellow = "#E8CD44"
    case purple = "#A5ADF5"
    case orange = "#F0B782"
    case green = "#699D84"
    
    static func setGradient(contentView: UIView, startColor: UIColor, endColor: UIColor) {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        let startPoint: UIColor = startColor
        let endPoint: UIColor = endColor
        gradientLayer.colors = [startPoint.cgColor, endPoint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.2)
        gradientLayer.cornerRadius = 10
        
        contentView.layer.addSublayer(gradientLayer)
    }
}

class MinimalCareerProfileCell: UICollectionViewCell {
    var userId: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 75 / 2
        image.clipsToBounds = true
        return image
    }()
    
    let nickName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 20, style: .bold)
        return label
    }()
    
    let careerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 18, style: .bold)
        return label
    }()
    
    let careerGrade: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 14, style: .light)
        return label
    }()

    func configure(_ info: UserModel) {
        setImageURL(url: info.userProfileImg)
        nickName.text = info.userNickname
        careerName.text = info.userJob
        careerGrade.text = UserWorkYear.chooseUserWorkYear(grade: info.userWork)
        userId = info.userId
        chooseProfileColor(fillColor: info.userProfileColor)
        setup()
    }
    
    func setImageURL(url: String) {
        let url = URL(string: url)
        if url == nil {
            profileImageView.image = UIImage(named: "basicProfile")
        } else {
            profileImageView.kf.setImage(with: url)
        }
    }
    
    func chooseProfileColor(fillColor: String) {
        if GradientColor.skyblue.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.skyblueGradientSP), endColor: .appColor(.skyblueGradientEP))
        } else if GradientColor.yellow.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.yellowGradientSP), endColor: .appColor(.yellowGradientEP))
        } else if GradientColor.purple.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.purpleGradientSP), endColor: .appColor(.purpleGradientEP))
        } else if GradientColor.green.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.greenGradientSP), endColor: .appColor(.greenGradientEP))
        } else if GradientColor.pink.rawValue == fillColor {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.pinkGradientSP), endColor: .appColor(.pinkGradientEP))
        } else {
            GradientColor.setGradient(contentView: contentView, startColor: .appColor(.orangeGradientSP), endColor: .appColor(.orangeGradientEP))
        }
    }
    
    override func prepareForReuse() {
        userId = -1
    }
    
    func setup() {
        [profileImageView, nickName, careerName, careerGrade]
            .forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(24)
            $0.width.height.equalTo(75)
            $0.top.equalToSuperview().offset(-30)
        }
        
        nickName.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(5)
            $0.top.equalTo(19)
        }
        
        careerName.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(profileImageView.snp.bottom).offset(11)
        }
        
        careerGrade.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(careerName.snp.bottom).offset(6)
        }
    }
}

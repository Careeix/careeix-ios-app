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

class CardProfileCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 89 / 2
        image.clipsToBounds = true
        image.backgroundColor = .systemBlue
        image.tintColor = .label
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
        let url = URL(string: info.userProfileImg ?? "")
        profileImageView.kf.setImage(with: url)
        nickName.text = info.userNickname
        careerName.text = info.userJob
        careerGrade.text = String(info.userWork)
        firstDetailCareerName.text = "#" + info.userDetailJobs[0]
        
        if info.userDetailJobs.count == 2 {
            firstDetailCareerName.text = "#" + info.userDetailJobs[0]
            secondDetailCareerName.text = "#" + info.userDetailJobs[1]
        } else {
            secondDetailCareerName.text = ""
        }
        
        if info.userDetailJobs.count == 3 {
            firstDetailCareerName.text = "#" + info.userDetailJobs[0]
            secondDetailCareerName.text = "#" + info.userDetailJobs[1]
            thirdDetailCareerName.text = "#" + info.userDetailJobs[2]
        } else {
            thirdDetailCareerName.text = ""
        }

        setup()
    }
    
    func setup() {
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
    
    func setupGradient() {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.contentView.bounds
        let startPoint = UIColor(red: 53/255, green: 120/255, blue: 181/255, alpha: 0.9).cgColor
        let endPoint = UIColor(red: 105/255, green: 175/255, blue: 239/255, alpha: 0.45).cgColor
        gradientLayer.colors = [startPoint, endPoint]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.2)
        
        contentView.layer.addSublayer(gradientLayer)
        
    }
}

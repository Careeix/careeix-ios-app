//
//  MinimalCareerProfile.swift
//  Careeix
//
//  Created by mingmac on 2022/10/14.
//

import Foundation
import SnapKit
import UIKit

/**
 2. 간편 커리어 프로필
    - Compositional Layout
        - cell 하나
    - Diffable Datasource
        - 뷰 안에 프로필 이미지, 닉네임, 직무, 연차, 상세 직무 태그
    - Snapshot
*/

class MinimalCareerProfileCell: UICollectionViewCell {
    var userId: Int = -1
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
        image.layer.cornerRadius = 75 / 2
        image.clipsToBounds = true
        image.backgroundColor = .systemBlue
        image.tintColor = .label
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
        profileImageView.image = UIImage(named: info.userProfileImg)
        nickName.text = info.userNickname
        careerName.text = info.userJob
        careerGrade.text = String(info.userWork)
        userId = info.userId
        setup()
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
    
    func setupGradient() {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.contentView.bounds
        let startPoint: UIColor = .appColor(.purpleGradientSP)
        let endPoint: UIColor = .appColor(.purpleGradientEP)
        gradientLayer.colors = [startPoint.cgColor, endPoint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.2)
        gradientLayer.cornerRadius = 10
        
        contentView.layer.addSublayer(gradientLayer)
        
    }
}

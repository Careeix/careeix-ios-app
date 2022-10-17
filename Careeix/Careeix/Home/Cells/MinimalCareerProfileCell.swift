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
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 75 / 2
        image.clipsToBounds = true
        image.backgroundColor = .systemBlue
        image.tintColor = .label
        return image
    }()
    
    let nickName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let careerName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let careerGrade: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    func configure(_ info: CareerModel) {
        logoImage.image = UIImage(systemName: "person")
        nickName.text = info.nickname
        careerName.text = info.careerName
        careerGrade.text = info.careerGrade
        
        setup()
    }
    
    func setup() {

        [logoImage, nickName, careerName, careerGrade]
            .forEach { contentView.addSubview($0) }
        
        logoImage.snp.makeConstraints {
            $0.leading.equalTo(24)
            $0.width.height.equalTo(75)
            $0.top.equalToSuperview().offset(-15)
        }
        
        nickName.snp.makeConstraints {
            $0.leading.equalTo(logoImage.snp.trailing).offset(5)
            $0.top.equalTo(19)
        }
        
        careerName.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(logoImage.snp.bottom).offset(11)
        }
        
        careerGrade.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(careerName.snp.bottom).offset(6)
        }
    }
}

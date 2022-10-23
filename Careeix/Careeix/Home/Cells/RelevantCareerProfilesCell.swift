//
//  OnboardingCollectionViewCell.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import UIKit
import SnapKit
import UIKit

/**
 3. 내 직무와 관련된 커리어 프로필
    - Compositional Layout
        - 3x2 그리드
    - Diffable Datasource
        - 직무, 연차, 상세 직무 태그
    - Snapshot
 */

class RelevantCareerProfilesCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let careerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 15, style: .semiBold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let careerGrade: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray10)
        label.font = .pretendardFont(size: 11, style: .regular)
        return label
    }()
    
    let firstDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray700)
        label.font = .pretendardFont(size: 10, style: .regular)
        return label
    }()

    let secondDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray700)
        label.font = .pretendardFont(size: 10, style: .regular)
        return label
    }()

    let thirdDetailCareerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray700)
        label.font = .pretendardFont(size: 10, style: .regular)
        return label
    }()
    
    func configure(_ info: RelevantCareerModel) {
        careerName.text = info.careerName
        careerGrade.text = info.careerGrade
        firstDetailCareerName.text = "#" + info.detailCareerName[0]
        
        if info.detailCareerName.count == 2 {
            firstDetailCareerName.text = "#" + info.detailCareerName[0]
            secondDetailCareerName.text = "#" + info.detailCareerName[1]
        } else {
            secondDetailCareerName.text = ""
        }
        
        if info.detailCareerName.count == 3 {
            firstDetailCareerName.text = "#" + info.detailCareerName[0]
            secondDetailCareerName.text = "#" + info.detailCareerName[1]
            thirdDetailCareerName.text = "#" + info.detailCareerName[2]
        } else {
            thirdDetailCareerName.text = ""
        }

        setup()
    }
    
    func setup() {
        [careerName, careerGrade, firstDetailCareerName, secondDetailCareerName, thirdDetailCareerName]
            .forEach { contentView.addSubview($0) }
        
        careerName.snp.makeConstraints {
            $0.leading.equalTo(11)
            $0.top.equalTo(15)
            $0.width.equalTo(83)
        }
        
        careerGrade.snp.makeConstraints {
            $0.top.equalTo(careerName.snp.bottom).offset(10)
            $0.leading.equalTo(11)
        }
        
        firstDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(11)
            $0.bottom.equalTo(secondDetailCareerName.snp.top).inset(2)
        }
        secondDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(firstDetailCareerName.snp.leading)
            $0.bottom.equalTo(thirdDetailCareerName.snp.top).inset(2)
        }
        
        thirdDetailCareerName.snp.makeConstraints {
            $0.leading.equalTo(secondDetailCareerName.snp.leading)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}


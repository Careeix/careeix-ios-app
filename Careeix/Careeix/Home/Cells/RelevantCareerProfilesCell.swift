//
//  OnboardingCollectionViewCell.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import UIKit
import SnapKit

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
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userId = 0
    
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
    
    func configure(_ info: RecommandUserModel) {
        userId = info.userId
        careerName.text = info.userJob
        careerGrade.text = UserWork.setUserWork(grade: info.userWork)
        contentView.layer.backgroundColor = UIColor(hexString: info.userProfileColor, alpha: 1).cgColor
        setUserDetailJobs(detailJobs: info.userDetailJobs)
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
    
    func setUI() {
        contentView.layer.cornerRadius = 10
        
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


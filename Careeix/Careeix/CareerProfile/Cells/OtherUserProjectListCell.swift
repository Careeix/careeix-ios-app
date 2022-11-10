//
//  OtherUserProjectListCell.swift
//  Careeix
//
//  Created by mingmac on 2022/11/10.
//

import Foundation
import UIKit
import SnapKit

class OtherUserProjectListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.date)
        label.font = .pretendardFont(size: 13, style: .semiBold)
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.date)
        label.font = .pretendardFont(size: 13, style: .semiBold)
        return label
    }()

    let projectTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 14, style: .semiBold)
        return label
    }()
    
    let projectClassificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray500)
        label.font = .pretendardFont(size: 13, style: .regular)
        return label
    }()
    
    let projecIntroduceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 13, style: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var projectId = -1
    
    override func prepareForReuse() {
        projectId = 0
    }
    
    func configure(_ info: ProjectModel) {
        projectId = info.project_id
        startDateLabel.text = info.start_date + "~"
        endDateLabel.text = info.is_proceed == 0 ? info.end_date : "진행 중"
        projectTitleLabel.text = info.title
        projectClassificationLabel.text = info.classification
        projecIntroduceLabel.text = info.introduction
    }
    
    func setUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.appColor(.gray200).cgColor
        contentView.layer.cornerRadius = 5
        
        [startDateLabel, endDateLabel, projectTitleLabel, projectClassificationLabel, projecIntroduceLabel]
            .forEach { contentView.addSubview($0) }
        
        startDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(15)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.leading.equalTo(startDateLabel.snp.trailing).offset(2)
            $0.top.equalTo(startDateLabel.snp.top)
        }
       
        projectTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(startDateLabel.snp.bottom).offset(15)
        }
        
        projectClassificationLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(projectTitleLabel.snp.bottom).offset(5)
        }
        
        projecIntroduceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(projectClassificationLabel.snp.bottom).offset(12)
        }
    }
}

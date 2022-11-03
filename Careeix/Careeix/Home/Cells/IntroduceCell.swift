//
//  IntroduceCell.swift
//  Careeix
//
//  Created by mingmac on 2022/10/24.
//

import Foundation
import UIKit
import SnapKit

class IntroduceCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel: UILabel = {
        let header = UILabel()
        header.text = "소개"
        header.textColor = .appColor(.gray200)
        header.font = .pretendardFont(size: 15, style: .bold)
        return header
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray250)
        label.font = .pretendardFont(size: 13, style: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        let lineColor: UIColor = .appColor(.line)
        view.layer.borderWidth = 1
        view.layer.borderColor = lineColor.cgColor
        return view
    }()
    
    var userId = 0
    
    func configure(_ info: UserModel) {
        userId = info.userId
        descriptionLabel.text = info.userIntro

        setUI()
    }
    
    func setUI() {
        [headerLabel, descriptionLabel, seperatorView].forEach { addSubview($0) }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(23)
            $0.top.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(headerLabel.snp.leading)
            $0.top.equalTo(headerLabel.snp.bottom).offset(4)
            $0.width.equalTo(331)
        }
        
        seperatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }
    }
}

//
//  EmptyCareerProfile.swift
//  Careeix
//
//  Created by mingmac on 2022/10/20.
//

import Foundation
import UIKit
import SnapKit

class EmptyCareerProfile: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emptyImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.tintColor = .appColor(.gray30)
        return image
    }()
    
    let largeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray200)
        label.font = .pretendardFont(size: 15, style: .medium)
        label.textAlignment = .center
        label.text = "관련된 커리어 프로필이 존재하지 않습니다."
        return label
    }()
    
    let smallLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray200)
        label.font = .pretendardFont(size: 14, style: .medium)
        label.textAlignment = .center
        label.text = "상세 직무 태그를 확인해보세요."
        return label
    }()
    
    func setup() {
        [emptyImageView, largeLabel, smallLabel].forEach { contentView.addSubview($0) }
        
        emptyImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        largeLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        smallLabel.snp.makeConstraints {
            $0.top.equalTo(largeLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
}

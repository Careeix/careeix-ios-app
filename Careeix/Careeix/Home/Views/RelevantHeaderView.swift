//
//  RelevantHeaderView.swift
//  Careeix
//
//  Created by mingmac on 2022/10/17.
//

import Foundation
import UIKit
import SnapKit

class RelevantHeaderView: UICollectionReusableView {
    
    static let identifier = "RelevantHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let header: UILabel = {
        let label = UILabel()
        label.text = "내 직무와 관련된 커리어 프로필"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    func setup() {
        addSubview(header)
        
        header.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13)
        }
    }
}

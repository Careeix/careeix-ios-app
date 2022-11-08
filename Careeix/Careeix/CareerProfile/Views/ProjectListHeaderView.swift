//
//  ProjectListHeaderView.swift
//  Careeix
//
//  Created by mingmac on 2022/11/05.
//

import Foundation
import UIKit
import SnapKit

class ProjectListHeaderView: UICollectionReusableView {
    static let identifier = "ProjectListHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let header: UILabel = {
        let label = UILabel()
        label.text = "프로젝트"
        label.font = .pretendardFont(size: 18, style: .bold)
        label.textColor = .appColor(.deep)
        return label
    }()
    
    func setup() {
        addSubview(header)
        header.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview()
        }
    }
}

//
//  MyPageHeaderView.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit

class MyPageHeaderView: UITableViewHeaderFooterView {
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray900)
        label.font = .pretendardFont(size: 18, style: .medium)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
        }
    }
}

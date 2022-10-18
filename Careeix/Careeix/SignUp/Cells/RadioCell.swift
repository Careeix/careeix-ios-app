//
//  RadioCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/16.
//

import UIKit

class RadioCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUI()
    }

    func configure() {
        selectionStyle = .none
        
        selectedMark.isHidden = true
        selectedMark.backgroundColor = .appColor(.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let label = UILabel()
    let selectedMark = UIView()
    func setUI() {
        [label, selectedMark].forEach { contentView.addSubview($0) }
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(48).priority(.high)
        }
        
        selectedMark.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }
}

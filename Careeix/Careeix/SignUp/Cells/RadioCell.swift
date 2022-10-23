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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 13, style: .regular)
        l.textColor = .appColor(.gray900)
        return l
    }()
    let selectedMark: UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .appColor(.main)
        v.layer.cornerRadius = 8.5
        return v
    }()
    let selectedMarkBorder: UIView = {
        let v = UIView()
        v.backgroundColor = .appColor(.white)
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.appColor(.gray100).cgColor
        return v
    }()
    func setUI() {
        [contentLabel, selectedMarkBorder, selectedMark, ].forEach { contentView.addSubview($0) }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.height.equalTo(48)
        }
        
        selectedMark.snp.makeConstraints {
            $0.width.height.equalTo(17)
            $0.right.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
        
        selectedMarkBorder.snp.makeConstraints {
            $0.center.equalTo(selectedMark)
            $0.width.height.equalTo(24)
        }
    }
}

//
//  ContentsAddButtonView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit

class ContentsAddButtonView: UIView {
    init(content: String = "") {
        super.init(frame: .zero)
        setUI()
        configure()
        label.text = "\(content)\(content == "" ? "" : " ")추가"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let contentView = UIView()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "plusIcon")
        return iv
    }()
    let label: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 14, style: .medium)
        l.textColor = .appColor(.gray600)
        return l
    }()
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        layer.borderWidth = 1
    }
}

extension ContentsAddButtonView {
    func setUI() {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [imageView, label].forEach { contentView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

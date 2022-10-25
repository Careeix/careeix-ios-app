//
//  ContentsAddButtonView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit

class ContentsAddButtonView: UIView {
    init(content: String = "", disableMessage: String = "") {
        super.init(frame: .zero)
        setUI()
        configure()
        enableLabel.text = "\(content)\(content == "" ? "" : " ")추가"
        disableLabel.text = disableMessage
        disableView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let enableView = UIView()
    let disableView = UIView()
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "plusIcon")
        return iv
    }()
    let enableLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 14, style: .medium)
        l.textColor = .appColor(.gray600)
        return l
    }()
    let disableLabel: UILabel = {
       let l = UILabel()
        l.font = .pretendardFont(size: 14, style: .medium)
        l.textColor = .appColor(.gray250)
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
        addSubview(enableView)
        
        enableView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [imageView, enableLabel].forEach { enableView.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        enableLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        addSubview(disableView)
        disableView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        disableView.addSubview(disableLabel)
        disableLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}

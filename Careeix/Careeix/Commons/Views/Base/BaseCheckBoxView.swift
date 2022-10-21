//
//  BaseCheckBoxView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit

struct BaseCheckBoxViewModel {
    
}

class BaseCheckBoxView: UIView {
    init() {
        super.init(frame: .zero)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let checkImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "checkmark")
        return iv
    }()
    
    func configure() {
        backgroundColor = .red
        layer.cornerRadius = 2
    }
    
    func setUI() {
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
    }
}

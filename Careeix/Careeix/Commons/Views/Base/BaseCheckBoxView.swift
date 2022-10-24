//
//  BaseCheckBoxView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit

class BaseCheckBoxView: UIView {
    var _isSelected: Bool = false
    var isSelected: Bool {
        get {
            return _isSelected
        }
        set (newVal) {
            _isSelected = newVal
            layer.borderWidth = _isSelected ? 0 : 1
            backgroundColor = _isSelected ? .appColor(.main) : .appColor(.white)
        }
    }
    
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
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

//
//  BaseInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit

class BaseInputView: UIView {
    let titleLabel = UILabel()
    var textField: BaseTextField = BaseTextField()
    
    init(viewModel: BaseInputViewModel) {
        super.init(frame: .zero)
        titleLabel.text = viewModel.title
        textField.placeholder = viewModel.placeholder
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [titleLabel, textField].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview()
        }
    }
}

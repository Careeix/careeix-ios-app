//
//  BaseInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit
import RxCocoa
// 기간 입력 시 사용
struct BaseInputViewModel {
    let contentDriver: Driver<String>
    
    init(content: String) {
        contentDriver = .just(content)
    }
}

class BaseInputView: UIView {
    
    func bind(to viewModel: BaseInputViewModel) {
        
    }
    init(viewModel: BaseInputViewModel) {
        super.init(frame: .zero)
        configure()
        setUI()
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let contentLabel = UILabel()
    
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        contentLabel.font = .pretendardFont(size: 13, style: .regular)
        
    }
    
    func setUI() {
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
    }
}

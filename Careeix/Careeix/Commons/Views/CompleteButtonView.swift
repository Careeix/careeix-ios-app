//
//  CompleteButtonView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit

class CompleteButtonView: UIView {
    init(content: String, backgroundColor: UIColor = .appColor(.signature)) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        contentLabel.text = content
        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let contentLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        return l
    }()
    
    func setUI() {
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
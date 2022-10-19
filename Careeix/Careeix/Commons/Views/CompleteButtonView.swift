//
//  CompleteButtonView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit

struct CompleteButtonViewModel {
    let content: String
    let backgroundColor: AssetsColor
    
    init(content: String, backgroundColor: AssetsColor) {
        self.content = content
        self.backgroundColor = backgroundColor
    }
}

class CompleteButtonView: UIView {
    init(viewModel: CompleteButtonViewModel) {
        super.init(frame: .zero)
        self.backgroundColor = .appColor(viewModel.backgroundColor)
        contentLabel.text = viewModel.content
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
        l.textColor = .appColor(.white)
        l.font = .pretendardFont(size: 16, style: .medium)
        return l
    }()
    
    func setUI() {
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

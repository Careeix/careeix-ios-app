//
//  BaseTextView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit
class BaseTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        font = .pretendardFont(size: 13, style: .regular)
    }
}

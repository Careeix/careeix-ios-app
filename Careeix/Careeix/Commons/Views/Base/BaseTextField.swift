//
//  BaseTextField.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import RxSwift
import RxCocoa
/// no intrinsic size
/// intrinsic size 없습니다
class BaseTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        setLeftPaddingPoints(15)
        font = .pretendardFont(size: 13, style: .regular)
    }
}
extension Reactive where Base: BaseTextField {
    var text: ControlProperty<String?> {
        value
    }
}


//
//  MyPageTableViewCell.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 0))
    }

}

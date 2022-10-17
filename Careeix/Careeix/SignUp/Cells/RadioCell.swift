//
//  RadioCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/16.
//

import UIKit

class RadioCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
//        layoutIfNeeded()
        print("Asd")
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let textField = BaseTextField()
    
    func setUI() {
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
}

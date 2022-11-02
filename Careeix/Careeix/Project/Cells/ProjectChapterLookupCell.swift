//
//  ProjectChapterLookupCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import UIKit

struct ProjectChapterLookupCellViewModel {
    let number: Int
    let title: String
}
class ProjectChapterLookupCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: ProjectChapterLookupCellViewModel) {
        numberLabel.text = "\(viewModel.number)"
        titleLabel.text = viewModel.title
    }
    
    // MARK: - UIComponents
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    
    func setUI() {
        [numberLabel, titleLabel].forEach { contentView.addSubview($0) }
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numberLabel.snp.trailing).offset(10)
        }
    }
}

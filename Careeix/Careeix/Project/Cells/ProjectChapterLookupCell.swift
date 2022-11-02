//
//  ProjectChapterLookupCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import UIKit

struct ProjectChapterLookupCellViewModel {
    let row: Int
    let projectChapter: ProjectChapter
}
class ProjectChapterLookupCell: UITableViewCell {
    
    var viewModel: ProjectChapterLookupCellViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: ProjectChapterLookupCellViewModel) {
        self.viewModel = viewModel
        // TODO: 숫자 앞에 0 채워넣기
        numberLabel.text = "\(viewModel.row)"
        titleLabel.text = viewModel.projectChapter.title
    }
    
    override func prepareForReuse() {
        viewModel = nil
    }
    // MARK: - UIComponents
    let numberLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .regular)
        return l
    }()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .light)
        return l
    }()
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

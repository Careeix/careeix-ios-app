//
//  ProjectLookupHeaderView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import UIKit

struct ProjectLookupHeaderViewModel {
    let title: String
    let division: String
    let startDateString: String
    let endDateString: String
}

class ProjectLookupHeaderView: UIView {
    func bind(to viewModel: ProjectLookupHeaderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = "\(viewModel.division) | \(viewModel.startDateString) ~ \(viewModel.endDateString)"
    }
    
    init(viewModel: ProjectLookupHeaderViewModel) {
        super.init(frame: .zero)
        setUI()
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    let chapterLabel: UILabel = {
        let l = UILabel()
        l.text = "목차"
        l.textColor = .appColor(.gray300)
        return l
    }()
    
    func setUI() {
        [titleLabel, descriptionLabel, chapterLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        chapterLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(37)
            $0.leading.equalTo(titleLabel)
        }
    }
}

//
//  ProjectLookupHeaderView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import UIKit

struct ProjectLookupHeaderViewModel {
    let projectBaseInfo: ProjectBaseInfo
}

class ProjectLookupHeaderView: UIView {
    func bind(to viewModel: ProjectLookupHeaderViewModel) {
        let projectBaseInfo = viewModel.projectBaseInfo
        titleLabel.text = projectBaseInfo.title
        descriptionLabel.text = description(classification: projectBaseInfo.classification,
                                            startDateString: projectBaseInfo.startDateString,
                                            endDateString: projectBaseInfo.endDateString ?? "진행중",
                                            isProceed: projectBaseInfo.isProceed)
    }
    
    func description(
        classification: String,
        startDateString: String,
        endDateString: String,
        isProceed: Bool
    ) -> String {
        return "\(classification) | \(startDateString)~\(isProceed ? "진행중" : endDateString)"
    }
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 20, style: .bold)
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 13, style: .regular)
        l.textColor = .appColor(.gray250)
        return l
    }()
    let chapterLabel: UILabel = {
        let l = UILabel()
        l.text = "목차"
        l.font = .pretendardFont(size: 17, style: .semiBold)
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

//
//  ProjectListCell.swift
//  Careeix
//
//  Created by mingmac on 2022/11/05.
//

import Foundation
import UIKit
import SnapKit

class ProjectListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        kebabImageView.isUserInteractionEnabled = true
        updataLabel.isUserInteractionEnabled = true
        deleteLabel.isUserInteractionEnabled = true
        tappedGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.date)
        label.font = .pretendardFont(size: 13, style: .semiBold)
        return label
    }()
    
    let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.date)
        label.font = .pretendardFont(size: 13, style: .semiBold)
        return label
    }()
    
    let kebabImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kebabIcon")
        return imageView
    }()
    
    let projectTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 14, style: .semiBold)
        return label
    }()
    
    let projectClassificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray500)
        label.font = .pretendardFont(size: 13, style: .regular)
        return label
    }()
    
    let projecIntroduceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 13, style: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let twoWayButtonView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.appColor(.white).cgColor
        view.layer.borderWidth = 0.1
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    let updataLabel: UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 13, style: .regular)
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        let lineColor: UIColor = .appColor(.line)
        view.layer.borderWidth = 1
        view.layer.borderColor = lineColor.cgColor
        return view
    }()
    
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "삭제하기"
        label.textColor = .appColor(.text)
        label.font = .pretendardFont(size: 13, style: .regular)
        return label
    }()
    
    var projectId = -1
    
    override func prepareForReuse() {
        projectId = 0
    }
    
    func tappedGesture() {
        let kebebTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapKebabImageView))
        kebabImageView.addGestureRecognizer(kebebTapGesture)
        let updateTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUpdateButtonView))
        updataLabel.addGestureRecognizer(updateTapGesture)
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDeleteButtonView))
        deleteLabel.addGestureRecognizer(deleteTapGesture)
    }
    
    @objc func didTapKebabImageView() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didTapKebabImageView"), object: nil)
        if twoWayButtonView.isHidden == true {
            twoWayButtonView.isHidden = false
        } else {
            twoWayButtonView.isHidden = true
        }
    }
    
    @objc func didTapUpdateButtonView() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didTapUpdateButtonView"), object: nil)
    }
    
    @objc func didTapDeleteButtonView() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didTapDeleteButtonView"), object: nil)
    }
    
    func configure(_ info: ProjectModel) {
        projectId = info.project_id
        startDateLabel.text = info.start_date + "~"
        endDateLabel.text = info.is_proceed == 0 ? info.end_date : "진행 중"
        projectTitleLabel.text = info.title
        projectClassificationLabel.text = info.classification
        projecIntroduceLabel.text = info.introduction
    }
    
    func setUI() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.appColor(.gray200).cgColor
        contentView.layer.cornerRadius = 5
        
        [startDateLabel, endDateLabel, kebabImageView, projectTitleLabel, projectClassificationLabel, projecIntroduceLabel]
            .forEach { contentView.addSubview($0) }
        
        startDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(15)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.leading.equalTo(startDateLabel.snp.trailing).offset(2)
            $0.top.equalTo(startDateLabel.snp.top)
        }
        
        kebabImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17)
            $0.top.equalTo(endDateLabel.snp.top)
        }
        
        projectTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(startDateLabel.snp.bottom).offset(15)
        }
        
        projectClassificationLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(projectTitleLabel.snp.bottom).offset(5)
        }
        
        projecIntroduceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(projectClassificationLabel.snp.bottom).offset(12)
        }
        
        contentView.addSubview(twoWayButtonView)
        
        twoWayButtonView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(213)
            $0.trailing.equalToSuperview().inset(8)
            $0.top.equalTo(kebabImageView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview().inset(5)
        }
        
        [updataLabel, seperatorView, deleteLabel].forEach { twoWayButtonView.addSubview($0) }
        
        updataLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
        }
        
        seperatorView.snp.makeConstraints {
            $0.top.equalTo(updataLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview().inset(6)
            $0.height.equalTo(1)
        }
        
        deleteLabel.snp.makeConstraints {
            $0.top.equalTo(seperatorView.snp.bottom).offset(11)
            $0.centerX.equalToSuperview()
        }
    }
}

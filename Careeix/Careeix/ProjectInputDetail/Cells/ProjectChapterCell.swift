//
//  ProjectChapterCellCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ProjectChapterCellViewModel {
    
    let indexDriver: Driver<String>
    let titleDriver: Driver<String>
    
    init(index: Int, title: String) {
        indexDriver = .just(String(index + 1))
        titleDriver = .just(title)
    }
}

class ProjectChapterCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    func bind(viewModel: ProjectChapterCellViewModel) {
        viewModel.indexDriver
            .drive(numberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    let numberLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .regular)
        l.textColor = .appColor(.gray900)
        return l
    }()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .regular)
        l.textColor = .appColor(.gray900)
        return l
    }()
    let modifyLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 14, style: .medium)
        l.text = "수정"
        l.textColor = .appColor(.point)
        return l
    }()
    
    func setUI() {
        [numberLabel, titleLabel, modifyLabel].forEach { contentView.addSubview($0) }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        
        modifyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numberLabel.snp.trailing).offset(23)
            $0.width.equalToSuperview().multipliedBy(0.75)
        }
    }
}

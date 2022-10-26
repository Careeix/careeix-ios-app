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
        indexDriver = .just(String(index))
        titleDriver = .just(title)
    }
}

class ProjectChapterCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
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
    
    let indexLabel = UILabel()
    
    func bind(viewModel: ProjectChapterCellViewModel) {
        viewModel.indexDriver
            .drive(indexLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setUI() {
        [indexLabel].forEach { contentView.addSubview($0) }
        
        indexLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
    }
}

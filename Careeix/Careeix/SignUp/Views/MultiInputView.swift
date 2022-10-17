//
//  MultiInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
class MultiInputView: UIView {
    let disposeBag = DisposeBag()
    init(viewModel: MultiInputViewModel) {
        titleLabel.text = viewModel.title
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let titleLabel = UILabel()
    let tableView: UITableView = {
       let tv = UITableView()
        tv.register(MultiInputCell.self, forCellReuseIdentifier: MultiInputCell.self.description())
        tv.isScrollEnabled = false
        tv.backgroundColor = .orange
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        return tv
    }()
    
}

extension MultiInputView {
    func setUI() {
        [titleLabel, tableView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(150)
        }
    }
}

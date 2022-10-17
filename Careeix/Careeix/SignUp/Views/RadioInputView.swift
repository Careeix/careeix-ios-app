//
//  RadioInputView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct RadioInputViewModel {
    // MARK: - Input
    var selectedIndexRelay = PublishRelay<IndexPath>()
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    let contentsDriver: Driver<[String]>
    
    init(title: String, contents: [String]) {
        titleStringDriver = Observable.just(title).asDriver(onErrorJustReturn: "")
        contentsDriver = Observable.just(contents).asDriver(onErrorJustReturn: [])
    }
}

class RadioInputView: UIView {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: RadioInputViewModel) {
        viewModel.titleStringDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.contentsDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: RadioCell.self.description(),for: IndexPath(row: row, section: 0)) as? RadioCell else { return UITableViewCell() }
                
                cell.label.text = data
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.selectedIndexRelay)
            .disposed(by: disposeBag)
        
        // 이전 행의 mark를 hidden 하고 새로 선택된 행의 mark를 표시합니다.
        viewModel.selectedIndexRelay
            .scan(IndexPath(row: -1, section: 0)){
                if let cell = self.tableView.cellForRow(at: $0) as? RadioCell {
                    cell.selectedMark.isHidden = true
                }
                return $1
            }.asDriver(onErrorJustReturn: IndexPath())
            .compactMap { self.tableView.cellForRow(at: $0) as? RadioCell }
            .asDriver(onErrorJustReturn: RadioCell())
            .drive { $0.selectedMark.isHidden = false }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    init(viewModel: RadioInputViewModel) {
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(RadioCell.self, forCellReuseIdentifier: RadioCell.self.description())
        tv.isScrollEnabled = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 48.0
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        return tv
    }()
}

extension RadioInputView {
    func setUI() {
        [titleLabel, tableView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(tableView.contentSize.height)
        }
    }
}

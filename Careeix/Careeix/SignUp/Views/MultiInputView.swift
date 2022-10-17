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

struct MultiInputViewModel {
    var multiInputCellViewModels: [MultiInputCellViewModel]
    
    // MARK: - Output
    let titleDriver:Driver<String>
    var inputValuesObservable: Observable<[String]>
    var placeholdersDriver: Driver<[String]>
    
    init(title: String, placeholders: [String]) {
        self.titleDriver =  Observable.just(title).asDriver(onErrorJustReturn: "")
        self.placeholdersDriver = Observable.just(placeholders).asDriver(onErrorJustReturn: [])
        self.multiInputCellViewModels = placeholders.map { .init(placeholder: $0) }
        self.inputValuesObservable = Observable
            .combineLatest(self.multiInputCellViewModels.map { $0.inputStringRelay })
    }
}

class MultiInputView: UIView {
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: MultiInputViewModel) {
        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.placeholdersDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: MultiInputCell.self.description(),for: IndexPath(row: row, section: 0)) as? MultiInputCell else { return UITableViewCell() }
                cell.textField.placeholder = data
                cell.viewModel = viewModel.multiInputCellViewModels[row]
                return cell
            }.disposed(by: disposeBag)
        
//        tableView.rx.delegat
    }
    
    // MARK: - Initializer
    init(viewModel: MultiInputViewModel) {
        super.init(frame: .zero)
        bind(to: viewModel)
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
        tv.estimatedRowHeight = 53.0
//        tv.inset
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
            $0.height.equalTo(tableView.contentSize.height)
        }
    }
}

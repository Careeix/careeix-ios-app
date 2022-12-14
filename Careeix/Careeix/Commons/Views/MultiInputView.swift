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
    let descriptionDriver: Driver<String>
    let inputValuesObservable: Observable<[String]>
    
    init(title: String, description: String, textFieldViewModels: [BaseTextFieldViewModel]) {
        titleDriver = .just(title)
        descriptionDriver = .just(description)
        multiInputCellViewModels = textFieldViewModels.map { .init(textFieldViewModel: $0) }
        inputValuesObservable = Observable
            .combineLatest(multiInputCellViewModels.map { $0.textFieldViewModel.inputStringRelay })
            .map { $0.filter { $0 != "" } }
    }
}

class MultiInputView: UIView {
    let disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: MultiInputViewModel) {
        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just(viewModel.multiInputCellViewModels)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: MultiInputCell.self.description(),for: IndexPath(row: row, section: 0)) as? MultiInputCell else { return UITableViewCell() }
                cell.viewModel = data
                return cell
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    init(viewModel: MultiInputViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUI()
        bind(to: viewModel)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        l.textColor = .appColor(.gray900)
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 10, style: .regular)
        l.textColor = .appColor(.gray300)
        l.text = "상세 직무 개수는 1~3개까지 입력 가능합니다."
        return l
    }()
    let tableView: UITableView = {
       let tv = UITableView()
        tv.register(MultiInputCell.self, forCellReuseIdentifier: MultiInputCell.self.description())
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.rowHeight = 53
        return tv
    }()
}

extension MultiInputView {
    func setUI() {
        [titleLabel, descriptionLabel, tableView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(11)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(53 * 3)
        }
    }
}

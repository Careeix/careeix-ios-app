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

protocol EventDelegate: AnyObject {
    func didTapRadioInputView()
}

class RadioInputViewModel {
    // MARK: - Input
    var selectedIndexRelay = PublishRelay<IndexPath>()
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    let contentsDriver: Driver<[String]>
    
    init(title: String, contents: [String]) {
        titleStringDriver = .just(title)
        contentsDriver = .just(contents)
        
    }
}

class RadioInputView: UIView {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var delegate: EventDelegate?
    
    // MARK: - Binding
    func bind(to viewModel: RadioInputViewModel) {
        viewModel.titleStringDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.contentsDriver
            .drive(tableView.rx.items) { tv, row, data in
                print("그려유", data)
                guard let cell = tv.dequeueReusableCell(withIdentifier: RadioCell.self.description(),for: IndexPath(row: row, section: 0)) as? RadioCell else { return UITableViewCell() }
                cell.contentLabel.text = data
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.selectedIndexRelay)
            .disposed(by: disposeBag)
        
        // 이전 행의 mark를 hidden 하고 새로 선택된 행의 mark를 표시합니다.
        viewModel.selectedIndexRelay
            .debug("😡셀 선택 ~!")
            .scan(IndexPath(row: -1, section: 0)){ [weak self] in
                if let cell = self?.tableView.cellForRow(at: $0) as? RadioCell {
                    cell.selectedMark.isHidden = true
                    cell.selectedMarkBorder.layer.borderColor = UIColor.appColor(.gray100).cgColor
                }
                return $1
            }.compactMap { [weak self] in
                self?.tableView.cellForRow(at: $0) as? RadioCell
            }.asDriver(onErrorJustReturn: RadioCell())
            .drive { [weak self] in
                self?.delegate?.didTapRadioInputView()
                $0.selectedMark.isHidden = false
                $0.selectedMarkBorder.layer.borderColor = UIColor.appColor(.main).cgColor
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - Initializer
    init(viewModel: RadioInputViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        bind(to: viewModel)
        setUI()
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
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(RadioCell.self, forCellReuseIdentifier: RadioCell.self.description())
        tv.isScrollEnabled = false
        tv.separatorInset.left = 0
        tv.rowHeight = 48
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.appColor(.gray100).cgColor
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(tableView.rowHeight * 5)
        }
    }
}

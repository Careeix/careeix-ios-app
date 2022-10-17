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



class RadioInputView: UIView {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var selected: Int?
    //    var contents: [String]
    
    // MARK: - Binding
    func bind(to viewModel: RadioInputViewModel) {
        viewModel.contentsDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: RadioCell.self.description(),for: IndexPath(row: row, section: 0)) as? RadioCell else { return UITableViewCell() }
                print("As")
                cell.backgroundColor = .red
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    init(viewModel: RadioInputViewModel) {
        titleLabel.text = viewModel.title
        //        self.contents = viewModel.contents
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
        //        print(tableView.contentSize.height)
        //        tableView.snp.updateConstraints {
        //            $0.height.equalTo(tableView.contentSize.height)
        //        }
        //        print(tableView.contentSize.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIComponents
    let titleLabel = UILabel()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(RadioCell.self, forCellReuseIdentifier: RadioCell.self.description())
        tv.isScrollEnabled = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 48.0
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
//            $0.height.equalTo(300)
        }
    }
}

//
//  NoteCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
struct NoteCellViewModel {
    var cellRow: Int
    let inputStringRelay: BehaviorRelay<String>

    init(inputStringRelay: BehaviorRelay<String>, row: Int) {
        self.inputStringRelay = inputStringRelay
        cellRow = row
    }
}

class NoteCell: UITableViewCell {
    let textView = BaseTextView()
    var viewModel: NoteCellViewModel? {
        didSet {
            guard let viewModel else { return }
            bind(to: viewModel)
        }
    }
    var disposeBag = DisposeBag()

    func bind(to viewModel: NoteCellViewModel) {
        textView.rx.text.orEmpty
            .do { print("\(viewModel.cellRow)의 내용:  \($0)") }
            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)
        
        viewModel.inputStringRelay
            .subscribe {
                print("asd", $0)
            }.disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        textView.delegate = nil
        textView.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.height.greaterThanOrEqualTo(179)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

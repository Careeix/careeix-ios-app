//
//  MultiInputCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/16.
//

import UIKit
import RxSwift
import RxCocoa

struct MultiInputCellViewModel {
    var inputStringRelay: PublishRelay<String>
    let placeholder: String
    
    init(inputStringRelay: PublishRelay<String> = PublishRelay<String>(), placeholder: String) {
        self.inputStringRelay = inputStringRelay
        self.placeholder = placeholder
    }
    
}

class MultiInputCell: UITableViewCell {
    var disposeBag = DisposeBag()
    var viewModel: MultiInputCellViewModel? {
        didSet {
            guard let viewModel else { return }
            bind(to: viewModel)
        }
    }
    
    func bind(to viewModel: MultiInputCellViewModel) {
        textField.rx.text.orEmpty
            .bind(to: viewModel.inputStringRelay)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Initializer
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    let textField = BaseTextField()
    let emptyView = UIView()
    func setUI() {
        [textField, emptyView].forEach { contentView.addSubview($0) }
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
//        emptyView.snp.makeConstraints {
//            $0.top.equalTo(textField.snp.bottom)
//            $0.height.equalTo(5)
//            $0.leading.trailing.equalToSuperview()
//        }
        
    }
}

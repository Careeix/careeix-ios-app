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
    var textFieldViewModel: BaseTextFieldViewModel
    
    init(textFieldViewModel: BaseTextFieldViewModel) {
        self.textFieldViewModel = textFieldViewModel
    }
}

class MultiInputCell: UITableViewCell {
    var disposeBag = DisposeBag()
    var viewModel: MultiInputCellViewModel? {
        didSet {
            guard let viewModel else { return }
            textField = BaseTextField(viewModel: viewModel.textFieldViewModel)
            setUI()
        }
    }
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        textField = BaseTextField(viewModel: .init())
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    var textField: BaseTextField
    let emptyView = UIView()
    func setUI() {
        [textField, emptyView].forEach { contentView.addSubview($0) }
        textField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
}

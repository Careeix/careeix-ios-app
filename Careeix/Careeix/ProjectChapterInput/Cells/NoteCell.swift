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
        
//        textView.snp.updateConstraints {
//            $0.height.greaterThanOrEqualTo(119)
//        }
//        UIView.animate(withDuration: 0.2) {
//            self.layoutIfNeeded()
//        }
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let noteView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.appColor(.gray100).cgColor
        v.backgroundColor = .appColor(.white)
        return v
    }()
    let topView = UIView()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "NOTE"
        l.font = .pretendardFont(size: 16, style: .semiBold)
        return l
    }()
    let deleteButtonImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "minusIcon")
        return iv
    }()
    let textView: BaseTextView = {
        let v = BaseTextView(viewModel: .init())
        v.backgroundColor = .clear
        v.layer.borderWidth = 0
        v.font = .pretendardFont(size: 13, style: .light)
        return v
    }()
    
    func setUI() {
        contentView.addSubview(noteView)
        
        noteView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [topView, textView].forEach { noteView.addSubview($0) }
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(-7)
            $0.height.greaterThanOrEqualTo(119)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }

        [titleLabel, deleteButtonImageView].forEach { topView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.leading.equalToSuperview().inset(20)
        }
        
        deleteButtonImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(15)
            $0.width.height.equalTo(24)
        }

    }
}

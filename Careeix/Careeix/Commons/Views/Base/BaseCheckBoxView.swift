//
//  BaseCheckBoxView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxGesture

struct BaseCheckBoxViewModel {
    let isSelectedRelay = BehaviorRelay<Bool>(value: false)
    let isSeclectedRelayShare: Observable<Bool>
   
    let isSelectedDriver: Driver<Bool>
    
    init() {
        isSeclectedRelayShare = isSelectedRelay.share()
        
        isSelectedDriver = isSeclectedRelayShare
            .asDriver(onErrorJustReturn: false)
    }
}

class BaseCheckBoxView: UIView {
    var disposeBag = DisposeBag()
    
    func bind(to viewModel: BaseCheckBoxViewModel) {
        viewModel.isSelectedDriver
            .drive(with: self) { owner, isSelected in
                owner.updateCheckBoxView(with: isSelected)
            }.disposed(by: disposeBag)
        
        rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .map {_ in !viewModel.isSelectedRelay.value }
            .bind(to: viewModel.isSelectedRelay)
            .disposed(by: disposeBag)
    }
    
    func updateCheckBoxView(with isSelected: Bool) {
        layer.borderWidth = isSelected ? 0 : 1
        backgroundColor = isSelected ? .appColor(.main) : .appColor(.white)
    }
    
    
    init(viewModel: BaseCheckBoxViewModel) {
        super.init(frame: .zero)
        bind(to: viewModel)
        configure()
        setUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let checkImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "checkmark")
        return iv
    }()
    
    func configure() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.gray100).cgColor
        layer.cornerRadius = 2
    }
    
    func setUI() {
        addSubview(checkImageView)
        
        checkImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
    }
}

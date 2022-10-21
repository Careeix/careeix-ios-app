//
//  TwoButtonAlertViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
struct TwoButtonAlertViewModel {
    let contentStringDriver: Driver<String>
    let leftButtonTextDriver: Driver<String>
    let leftTextColorDriver: Driver<AssetsColor>
    let rightButtonTextDriver: Driver<String>
    let rightTextColorDriver: Driver<AssetsColor>
    
    
    
    init(content: String, leftString: String, leftColor: AssetsColor, rightString: String, rightColor: AssetsColor) {
        contentStringDriver = .just(content)
        leftButtonTextDriver = .just(leftString)
        leftTextColorDriver = .just(leftColor)
        rightButtonTextDriver = .just(rightString)
        rightTextColorDriver = .just(rightColor)
        
    }
    
}
class TwoButtonAlertViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: TwoButtonAlertViewModel) {
        viewModel.contentStringDriver
            .drive(contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.leftButtonTextDriver
            .drive(leftLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.leftTextColorDriver
            .map(UIColor.appColor)
            .drive(leftLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.rightButtonTextDriver
            .drive(rightLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.rightTextColorDriver
            .map(UIColor.appColor)
            .drive(rightLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        leftLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        contentView.backgroundColor = .appColor(.white)
        contentView.layer.cornerRadius = 10
    }
    
    // MARK: - Initializer
    init(viewModel: TwoButtonAlertViewModel) {
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
        setUI()
        configure()
        [contentLabel, leftLabel, rightLabel].forEach(labelBuilder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UIComponents
    let contentView = UIView()
    let contentLabel = UILabel()
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    func labelBuilder(_ sender: UILabel) {
        sender.font = .pretendardFont(size: 15,
                                      style: sender == leftLabel
                                      ? .light
                                      : .regular)
        sender.textAlignment = .center
    }
    
    func setUI() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(343 / 375.0)
            $0.height.equalToSuperview().multipliedBy(166 / 812.0)
        }
        
        [contentLabel, leftLabel, rightLabel].forEach { contentView.addSubview($0) }
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.7)
        }
        
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.centerY.equalToSuperview().multipliedBy(1.6)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        rightLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.centerY.equalTo(leftLabel)
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
}

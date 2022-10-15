//
//  OnboardCell.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import SnapKit

struct OnboardCellViewModel {
    let imageNameDriver: Driver<String>
    
    init(imageName: String) {
        imageNameDriver = Observable.just(imageName).asDriver(onErrorJustReturn: "")
    }
}
class OnboardCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    let imageView = UIImageView()
    
    func bind(to viewModel: OnboardCellViewModel) {
        viewModel.imageNameDriver
            .map { UIImage(named: $0) }
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .red
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func setUI() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

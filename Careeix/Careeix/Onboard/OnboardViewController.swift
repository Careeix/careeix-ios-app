//
//  JHViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/05.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import SnapKit
import RxGesture
class OnboardViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel = OnboardViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind(to: viewModel)
    }
    
    // MARK: - Binding
    func bind(to viewModel: OnboardViewModel) {
        viewModel.logoImageNameDriver
            .map { UIImage(named: $0) }
            .drive(logoImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.kakaoLoginButtonImageNameDriver
            .map { UIImage(named: $0) }
            .drive(kakaoLoginButtonImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.appleLoginButtonImageNameDriver
            .map { UIImage(named: $0) }
            .drive(appleLoginButtonImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.onboardImageNamesDriver
            .do { self.pageControl.numberOfPages = $0.count }
            .drive(onboardCollectionView.rx.items) { collectionView, row, data in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCell.self.description(), for: IndexPath(row: row, section: 0)) as? OnboardCell else { return UICollectionViewCell() }
                cell.bind(to: .init(imageName: data))
                return cell
            }.disposed(by: disposeBag)
        
        onboardCollectionView.rx.willEndDragging
            .withUnretained(self)
            .map { ($1.targetContentOffset.pointee.x, $0.view.frame.width) }
            .bind(to: viewModel.endDraggingRelay)
            .disposed(by: disposeBag)

        viewModel.currentPageDriver
            .drive(pageControl.rx.currentPage)
            .disposed(by: disposeBag)
        
        kakaoLoginButtonImageView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind { viewModel.didTapKakaoLoginButton() }
            .disposed(by: disposeBag)
        
        appleLoginButtonImageView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                print("애플 로그인!")
            }.disposed(by: disposeBag)
    }
    
    // MARK: - UIComponents
    let logoImageView = UIImageView()
    lazy var onboardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = .init(width: view.frame.width, height: view.frame.width * 354 / 376.0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(OnboardCell.self, forCellWithReuseIdentifier: OnboardCell.self.description())
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .darkGray
        return pc
    }()
    let kakaoLoginButtonImageView = UIImageView()
    let appleLoginButtonImageView = UIImageView()
}

extension OnboardViewController {
    func setUI() {
        [logoImageView, onboardCollectionView, pageControl, kakaoLoginButtonImageView, appleLoginButtonImageView].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(61)
        }
        
        appleLoginButtonImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(61)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButtonImageView.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButtonImageView.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButtonImageView.snp.top).offset(-58)
            $0.centerX.equalToSuperview()
        }
        
        onboardCollectionView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(62)
            $0.bottom.equalTo(pageControl).offset(-60)
            $0.leading.trailing.equalToSuperview()
        }
    }
}



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

enum TwoButtonAlertType: String {
    case askingKeepWriting = "계속해서 등록하시겠습니까?"
    case warningDeleteNote = "NOTE를 삭제하시겠습니까?"
    case askingPublishProject = "발행하시겠습니까?"
    case userReportwarning = "해당 유저를 신고하시겠습니까?"
    case warningCancelWriting = "정말로 나가시겠습니까?"
    case warningLogoutWriting = "로그아웃하시겠습니까?"
    case warningSecession = "탈퇴 하시겠습니까?"
    case deleteProject = "프로젝트를 삭제하시겠습니까?"
    
    func getLeftButtonString() -> String {
        switch self {
        default:
            return "취소"
        }
    }
    
    func getLeftButtonColor() -> AssetsColor {
        switch self {
        default:
            return .gray400
        }
    }
    
    func getRightButtonString() -> String {
        switch self {
        case .warningDeleteNote:
            return "삭제"
        case .askingPublishProject:
            return "발행"
        case .userReportwarning:
            return "신고"
        case .warningLogoutWriting:
            return "로그아웃"
        case .warningSecession:
            return "탈퇴"
        case .deleteProject:
            return "삭제"
        default:
            return "확인"
        }
    }
    func getRightButtonColor() -> AssetsColor {
        switch self {
        default:
                return .error
        }
    }
}

protocol TwoButtonAlertViewDelegate: AnyObject {
    func didTapRightButton(type: TwoButtonAlertType)
    func didTapLeftButton(type: TwoButtonAlertType)
}

struct TwoButtonAlertViewModel {
    let type: TwoButtonAlertType
    
    // MARK: Output
    let contentStringDriver: Driver<String>
    let leftButtonTextDriver: Driver<String>
    let leftTextColorDriver: Driver<AssetsColor>
    let rightButtonTextDriver: Driver<String>
    let rightTextColorDriver: Driver<AssetsColor>
    
    init(type: TwoButtonAlertType) {
        contentStringDriver = .just(type.rawValue)
        leftButtonTextDriver = .just(type.getLeftButtonString())
        leftTextColorDriver = .just(type.getLeftButtonColor())
        rightButtonTextDriver = .just(type.getRightButtonString())
        rightTextColorDriver = .just(type.getRightButtonColor())
        self.type = type
    }
}

class TwoButtonAlertViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var delegate: TwoButtonAlertViewDelegate?
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
                owner.contentLabel.text = "처리중..."
                owner.delegate?.didTapLeftButton(type: viewModel.type)
            }.disposed(by: disposeBag)
        
        rightLabel.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.contentLabel.text = "처리중..."
                owner.delegate?.didTapRightButton(type: viewModel.type)
            }.disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
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
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
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
}

extension TwoButtonAlertViewController {
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

//
//  AddProjectViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import UIKit
import RxCocoa
import RxRelay
import RxSwift

struct PeriodInputViewModel {
    
    let startDateViewModel: BaseInputViewModel
    let endDateViewModel: BaseInputViewModel
    
    // MARK: Input
    let startDateTappedRelay = PublishRelay<Void>()
    let endDateTappedRelay = PublishRelay<Void>()
    
    // MARK: Output
    let titleDriver: Driver<String>
    let descriptionDriver: Driver<String>
    //    let startDateDriver: Driver<String>
    //    let endDateDriver: Driver<String>
    init(title: String) {
        titleDriver = .just(title)
        descriptionDriver = .just("프로젝트 기간을 입력해주세요.")
        startDateViewModel = .init(content: Date().toString())
        endDateViewModel = .init(content: Date().toString())
    }
}

class PeriodInputView: UIView {
    let disposeBag = DisposeBag()
    
    func bind(to viewModel: PeriodInputViewModel) {
        viewModel.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    init(viewModel: PeriodInputViewModel) {
        startDateView = .init(viewModel: viewModel.startDateViewModel)
        endDateView = .init(viewModel: viewModel.endDateViewModel)
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 12, style: .regular)
        return l
    }()
    let startDateView: BaseInputView
    let endDateView: BaseInputView
    let middleLabel: UILabel = {
        let l = UILabel()
        l.text = "~"
        l.textColor = .appColor(.gray600)
        l.font = .pretendardFont(size: 16, style: .semiBold)
        return l
    }()
    let proceedingCheckBox = BaseCheckBoxView()
    let proceedingLabel: UILabel = {
        let l = UILabel()
        l.text = "진행 중"
        l.textColor = .appColor(.error)
        l.font = .pretendardFont(size: 12, style: .regular)
        return l
    }()
}

extension PeriodInputView {
    func setUI() {
        [titleLabel, descriptionLabel, startDateView, middleLabel, endDateView, proceedingCheckBox, proceedingLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel)
        }
        
        middleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
        
        startDateView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(middleLabel.snp.leading).offset(-6)
            $0.height.equalTo(48)
            $0.centerY.equalTo(middleLabel)
        }
        
        endDateView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(middleLabel.snp.trailing).offset(6)
            $0.height.equalTo(48)
            $0.centerY.equalTo(middleLabel)
        }
        
        proceedingCheckBox.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.leading.equalTo(endDateView)
            $0.top.equalTo(endDateView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }

        proceedingLabel.snp.makeConstraints {
            $0.leading.equalTo(proceedingCheckBox.snp.trailing).offset(8)
            $0.top.equalTo(endDateView.snp.bottom).offset(11)
        }
    }
}

struct BaseCheckBoxViewModel {
    
}
class BaseCheckBoxView: UIView {
    init() {
        super.init(frame: .zero)
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
        backgroundColor = .red
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


struct ManyInputViewModel {
    // MARK: - Input
    let inputStringRelay = PublishRelay<String>()
    
    // MARK: - Output
    let titleStringDriver: Driver<String>
    let placeholderStringDriver: Driver<String>
    init(title: String, placeholder: String) {
        titleStringDriver = Observable.just(title).asDriver(onErrorJustReturn: "")
        placeholderStringDriver = Observable.just(placeholder).asDriver(onErrorJustReturn: "")
    }
}

class ManyInputView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: ManyInputViewModel) {
        viewModel.titleStringDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
//        viewModel.placeholderStringDriver
//            .drive(.rx.placeholder)
//            .disposed(by: disposeBag)
        
//        textField.rx.text.orEmpty
//            .bind(to: viewModel.inputStringRelay)
//            .disposed(by: disposeBag)
    }
    
    // MARK: Initializer
    init(viewModel: ManyInputViewModel) {
        super.init(frame: .zero)
        bind(to: viewModel)
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        l.textColor = .appColor(.gray900)
        return l
    }()
    var textView: BaseTextView = BaseTextView()
    
    
    func setUI() {
        [titleLabel, textView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.height.equalTo(91)
            $0.bottom.equalToSuperview()
        }
    }
}


struct AddProjectViewModel {
    let titleSimpleInputViewModel: SimpleInputViewModel
    let periodInputViewModel: PeriodInputViewModel
    let divisionInputViewModel: SimpleInputViewModel
    let introduceInputViewModel: ManyInputViewModel
}

class AddProjectViewController: UIViewController {
    // MARK: Properties
    
    init(viewModel: AddProjectViewModel) {
        titleSimpleInputView = .init(viewModel: viewModel.titleSimpleInputViewModel)
        periodInputView = .init(viewModel: viewModel.periodInputViewModel)
        divisionInputView = .init(viewModel: viewModel.divisionInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        super.init(nibName: nil, bundle: nil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UIComponents
    //    let progressView
    let titleSimpleInputView: SimpleInputView
    let periodInputView: PeriodInputView
    let divisionInputView: SimpleInputView
    let introduceInputView: ManyInputView
}

extension AddProjectViewController {
    func setUI() {
        [titleSimpleInputView, periodInputView, divisionInputView, introduceInputView].forEach { view.addSubview($0) }
        
        titleSimpleInputView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        periodInputView.snp.makeConstraints {
            $0.top.equalTo(titleSimpleInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        divisionInputView.snp.makeConstraints {
            $0.top.equalTo(periodInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        introduceInputView.snp.makeConstraints {
            $0.top.equalTo(divisionInputView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

//
//  UpdateProfileViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay
import RxKeyboard

struct UpdateProfileModel {
    let userDetailJob: [String]
    let userIntro: String
    let userJob: String
    let userWork: Int
}

struct UpdateProfileViewModel {
    typealias job = String
    typealias annual = Int
    typealias detailJobs = [String]
    typealias introduce = String
    
    let userRepository = UserRepository()
    
    // MARK: SubViewModels
    let jobInputViewModel: SimpleInputViewModel
    let annualInputViewModel: RadioInputViewModel
    let detailJobsInputViewModel: MultiInputViewModel
    let introduceInputViewModel: ManyInputViewModel
    let completeButtonViewModel: CompleteButtonViewModel
    
    // MARK: Inputs
    let viewDidLoadRelay = PublishRelay<Void>()
    let completeButtonTrigger = PublishRelay<Void>()
    
    // MARK: Outputs
    let fillDataDriver: Driver<(job, annual, detailJobs, introduce)>
    let alertDriver: Driver<String>
    
    init(jobInputViewModel: SimpleInputViewModel,
         annualInputViewModel: RadioInputViewModel,
         detailJobsInputViewModel: MultiInputViewModel,
         introduceInputViewModel: ManyInputViewModel,
         completeButtonViewModel: CompleteButtonViewModel) {
        self.jobInputViewModel = jobInputViewModel
        self.annualInputViewModel = annualInputViewModel
        self.detailJobsInputViewModel = detailJobsInputViewModel
        self.introduceInputViewModel = introduceInputViewModel
        self.completeButtonViewModel = completeButtonViewModel
        
        fillDataDriver = viewDidLoadRelay
            .map { _ in
                let user = UserDefaultManager.user
                return (user.userJob, user.userWork, user.userDetailJobs, user.userIntro ?? "")
            }.asDriver(onErrorJustReturn: ("", 0, [""], ""))
        
        // NOTE: 마지막값 안들어온다
        let combinedInputValuesObservable =  Observable.combineLatest(
            jobInputViewModel.textfieldViewModel.inputStringRelay,
            annualInputViewModel.selectedIndexRelay,
            detailJobsInputViewModel.inputValuesObservable,
            introduceInputViewModel.baseTextViewModel.inputStringRelay
        ).share().debug("🐷")
        
        alertDriver = completeButtonTrigger
            .withLatestFrom(combinedInputValuesObservable)
            .map { UpdateProfileModel(userDetailJob: $0.2, userIntro: $0.3, userJob: $0.0, userWork: $0.1.row)}
            .debug("dd??")
            .map { _ in "API 엮어야해 ~" }
            .asDriver(onErrorJustReturn: "")
        
        
        func updateUser(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
                
        }
    }
    func fillData(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
        jobInputViewModel.textfieldViewModel.inputStringRelay.accept(job)
        annualInputViewModel.selectedIndexRelay.accept(IndexPath(row: annual, section: 0))
        zip(detailJobsInputViewModel.multiInputCellViewModels, detailJobs).forEach {
            print("왜!!!", $0.1)
            $0.0.textFieldViewModel.setText($0.1)
        }
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(introduce)
    }
}

class UpdateProfileViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: UpdateProfileViewModel
    
    // MARK: - Bindings
    func bind(to viewModel: UpdateProfileViewModel) {
        
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
            }.disposed(by: disposeBag)

        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.completeButtonTrigger)
            .disposed(by: disposeBag)
        
        viewModel.fillDataDriver
            .drive(with: self) { owner, data in
                viewModel.fillData(job: data.0, annual: data.1, detailJobs: data.2, introduce: data.3)
            }.disposed(by: disposeBag)
        
        viewModel.alertDriver
            .drive(with: self) { owner, message in
                let vc = OneButtonAlertViewController(viewModel: .init(content: message, buttonText: "확인", textColor: .black))
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    func updateView(with keyboardHeight: CGFloat) {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        completeButtonView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    // MARK: - Initializer
    init(viewModel: UpdateProfileViewModel) {
        self.viewModel = viewModel
        jobInputView = .init(viewModel: viewModel.jobInputViewModel)
        annualInputView = .init(viewModel: viewModel.annualInputViewModel)
        detailJobTagInputView = .init(viewModel: viewModel.detailJobsInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        completeButtonView = .init(viewModel: viewModel.completeButtonViewModel)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .appColor(.white)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoadRelay.accept(())
    }
    // MARK: - Components
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    let contentView = UIView()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "커리어 프로필 수정"
        l.font = .pretendardFont(size: 22, style: .semiBold)
        return l
    }()
    let jobInputView: SimpleInputView
    let annualInputView: RadioInputView
    let detailJobTagInputView: MultiInputView
    let introduceInputView: ManyInputView
    let completeButtonView: CompleteButtonView
}

extension UpdateProfileViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        [titleLabel, jobInputView, annualInputView, detailJobTagInputView, introduceInputView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(24)
        }
        
        jobInputView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(39)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        annualInputView.snp.makeConstraints {
            $0.top.equalTo(jobInputView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        detailJobTagInputView.snp.makeConstraints {
            $0.top.equalTo(annualInputView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        introduceInputView.snp.makeConstraints {
            $0.top.equalTo(detailJobTagInputView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(138)
        }
        
        view.addSubview(completeButtonView)
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(78)
            $0.bottom.equalToSuperview()
        }
    }
}

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
    
    // MARK: Outputs
    let fillDataDriver: Driver<(job, annual, detailJobs, introduce)>
    
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
        

        
        func updateUser(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
                
        }
    }
    func fillData(job: job, annual: annual, detailJobs: detailJobs, introduce: introduce) {
        jobInputViewModel.textfieldViewModel.inputStringRelay.accept(job)
        annualInputViewModel.selectedIndexRelay.accept(IndexPath(row: annual, section: 0))
        zip(detailJobsInputViewModel.multiInputCellViewModels, detailJobs).forEach {
            print(detailJobsInputViewModel.multiInputCellViewModels, detailJobs)
            $0.textFieldViewModel.inputStringRelay.accept($1)
        }
        introduceInputViewModel.baseTextViewModel.inputStringRelay.accept(introduce)
    }
}

class UpdateProfileViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    // MARK: - Bindings
    func bind(to viewModel: UpdateProfileViewModel) {
        viewModel.fillDataDriver
            .drive(with: self) { owner, data in
                print(data)
                viewModel.fillData(job: data.0, annual: data.1, detailJobs: data.2, introduce: data.3)
            }.disposed(by: disposeBag)
    }
    // MARK: - Functions
    
    // MARK: - Initializer
    init(viewModel: UpdateProfileViewModel) {
        jobInputView = .init(viewModel: viewModel.jobInputViewModel)
        annualInputView = .init(viewModel: viewModel.annualInputViewModel)
        detailJobTagInputView = .init(viewModel: viewModel.detailJobsInputViewModel)
        introduceInputView = .init(viewModel: viewModel.introduceInputViewModel)
        completeButtonView = .init(viewModel: viewModel.completeButtonViewModel)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        view.backgroundColor = .appColor(.white)
        setUI()
        bind(to: viewModel)
        viewModel.viewDidLoadRelay.accept(())
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
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
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
}

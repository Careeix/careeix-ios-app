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
            .debug("데이터 채워야해 ~")
            .drive { data in
                viewModel.fillData(job: data.0, annual: data.1, detailJobs: data.2, introduce: data.3)
            }.disposed(by: disposeBag)
        
        viewModel.alertDriver
            .drive(with: self) { owner, message in
                let vc = OneButtonAlertViewController(viewModel: .init(content: message, buttonText: "확인", textColor: .error))
                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.updateDataDriver
            .drive { data in
                viewModel.updateUser(job: data.0, annual: data.1, detailJobs: data.2, introduce: data.3)
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
        bind(to: viewModel)
        setupNavigationBackButton()
        introduceInputView.textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
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

extension UpdateProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text else { return false }
        if text.contains("\n") {
            textView.text = text.replacingOccurrences(of: "\n", with: "")
        }
        return text.count < 55 || range.length == 1
    }

}

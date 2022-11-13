//
//  ProjectViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxGesture

class ProjectLookupViewController: UIViewController {
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: ProjectLookupViewModel
    
    // MARK: - Binding
    func bind(to viewModel: ProjectLookupViewModel) {
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.showAlert(.askingPublishProject)
            }.disposed(by: disposeBag)
        
        viewModel.lookupCellDataDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ProjectChapterLookupCell.self.description(), for: IndexPath(row: row, section: 0)) as? ProjectChapterLookupCell else { return UITableViewCell() }
                cell.bind(to: .init(row: row + 1, projectChapter: data))
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.projectBaseInfo
            .map { $0.title }
            .bind { title in
                viewModel.title = title
            }.disposed(by: disposeBag)
        
        viewModel.headerViewDataDriver
            .drive(with: self) { owner, projectBaseInfo in
                owner.headerView.bind(to: .init(projectBaseInfo: projectBaseInfo))
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .map { owner, indexPath -> (Int, ProjectChapter) in
                guard let cell = owner.tableView.cellForRow(at: indexPath) as? ProjectChapterLookupCell else { return (0, .init(title: "", content: "", notes: []))}
                return (indexPath.row, cell.viewModel.projectChapter)
            }.asDriver(onErrorJustReturn: (0, .init(title: "", content: "", notes: [])))
            .drive(with: self) { owner, info in
                owner.navigationController?.pushViewController(ProjectChapterViewController(viewModel: .init(title: viewModel.title, number: info.0 + 1, projectChapter: info.1)), animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.showPrevViewDriver
            .drive(with: self) { owner, response in
                owner.dismiss(animated: false)
                owner.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateProject"), object: nil)
            }.disposed(by: disposeBag)
        
        viewModel.showErrorAlertViewDriver
            .drive(with: self) { owner, message in
                owner.dismiss(animated: false)
                owner.showWarnningAlert(message)
            }.disposed(by: disposeBag)
    }
    
    func showWarnningAlert(_ message: String) {
        let vc = OneButtonAlertViewController(viewModel: .init(content: message, buttonText: "확인", textColor: .black))
        present(vc, animated: true)
    }
    
    func showAlert(_ type: TwoButtonAlertType) {
        let vc = TwoButtonAlertViewController(viewModel: .init(type: type))
        vc.delegate = self
        present(vc, animated: true)
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectLookupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
        completeButtonView.isHidden = !viewModel.isWriting
        hidesBottomBarWhenPushed = true
        print(viewModel.projectId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appColor(.white)
        setupNavigationBackButton()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if let navigationController = navigationController as? NavigationController, viewModel.isWriting {
            navigationController.updateProgressBar(progress: 1)
        }
    }
    
    // MARK: - UIComponents
    lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.backgroundColor = .appColor(.white)
        v.showsVerticalScrollIndicator = false
        v.register(ProjectChapterLookupCell.self, forCellReuseIdentifier: ProjectChapterLookupCell.self.description())
        v.delegate = self
        v.rowHeight = 60
        v.separatorStyle = .none
        return v
    }()
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "발행하기", backgroundColor: .next))
    let headerView = ProjectLookupHeaderView()
}

extension ProjectLookupViewController {
    func setUI() {
        [tableView, completeButtonView].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
        
        completeButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(78)
        }
    }
}

extension ProjectLookupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 108
    }
}

extension ProjectLookupViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        viewModel.updateTrigger.accept(())
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
    }
    
    
}

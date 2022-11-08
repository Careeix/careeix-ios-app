//
//  AddProjectDetailViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ProjectInputDetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProjectInputDetailViewModel
    
    // MARK: Binding
    func bind(to viewModel: ProjectInputDetailViewModel) {
        
        addButtonView.rx.tapGesture()
            .when(.recognized)
            .map { _ in () }
            .bind(to: viewModel.createTrigger)
            .disposed(by: disposeBag)
        
        viewModel.createIndexDriver
            .drive(with: self) { owner, index in
                owner.showProjectChapterInputViewController(index: index)
            }.disposed(by: disposeBag)
        
        viewModel.chaptersDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ProjectChapterCell.self.description(), for: IndexPath(row: row, section: 0)) as? ProjectChapterCell else { return UITableViewCell() }
                cell.bind(viewModel: .init(index: row, title: data.title))
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.showProjectChapterInputViewController(index: indexPath.row)
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.pushViewController(ProjectLookupViewController(viewModel: .init(projectId: viewModel.projectId)), animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.updateTableViewHeightDriver
            .drive(with: self) { owner, height in
                owner.tableView.snp.updateConstraints {
                    $0.height.equalTo(height * owner.tableView.rowHeight)
                }
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    func showProjectChapterInputViewController(index: Int) {
        navigationController?.pushViewController(ProjectChapterInputViewController(viewModel: .init(currentIndex: index)), animated: true)
    }
    
    func updateCompleteButtonView() {
        completeButtonView.isUserInteractionEnabled = !(UserDefaultManager.projectChaptersInputCache.count == 0)
        completeButtonView.backgroundColor = completeButtonView.isUserInteractionEnabled ? .appColor(.next) : .appColor(.disable)
    }
    
    // MARK: Initializer
    init(viewModel: ProjectInputDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupNavigationBackButton()
        setUI()
        bind(to: viewModel)
        view.backgroundColor = .appColor(.white)
        updateCompleteButtonView()
        hidesBottomBarWhenPushed = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppearRelay.accept(())
        if let navigationController = navigationController as? NavigationController {
            navigationController.updateProgressBar(progress: 2 / 3.0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: UIComponents
    let titleLabel: UILabel = {
       let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .semiBold)
        l.text = "내용"
        return l
    }()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.register(ProjectChapterCell.self, forCellReuseIdentifier: ProjectChapterCell.self.description())
        tv.rowHeight = 42
        tv.separatorStyle = .none
        
        return tv
    }()
    let addButtonView = ContentsAddButtonView()
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "미리보기", backgroundColor: .white))
}

extension ProjectInputDetailViewController {
    func setUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        [titleLabel, tableView, addButtonView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21)
            $0.leading.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(0)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        addButtonView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(80)
        }
        
        view.addSubview(completeButtonView)
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(78)
        }
    }
}

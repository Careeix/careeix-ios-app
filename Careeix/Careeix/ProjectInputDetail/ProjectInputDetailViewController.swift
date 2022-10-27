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

struct ProjectInputDetailViewModel {
    // MARK: Input
    let viewWillAppearRelay = PublishRelay<Void>()
    
    // MARK: Output
    let chaptersDriver: Driver<[ProjectChapter]>
    
    init() {
        chaptersDriver = viewWillAppearRelay
            .map { _ in UserDefaultManager.shared.projectChapters }
            .asDriver(onErrorJustReturn: [])
    }
}

class ProjectInputDetailViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProjectInputDetailViewModel
    
    // MARK: Binding
    func bind(to viewModel: ProjectInputDetailViewModel) {
        addButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.navigationController?.pushViewController(ProjectChapterInputViewController(viewModel: .init(currentIndex: UserDefaultManager.shared.projectChapters.count)), animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.chaptersDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ProjectChapterCell.self.description(), for: IndexPath(row: row, section: 0)) as? ProjectChapterCell else { return UITableViewCell() }
                cell.bind(viewModel: .init(index: row + 1, title: data.title))
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                owner.navigationController?.pushViewController(ProjectChapterInputViewController(viewModel: .init(currentIndex: indexPath.row)), animated: true)
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                print("발행전 데이터 확인")
                print(UserDefaultManager.shared.projectInput)
                print(UserDefaultManager.shared.projectChapters)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    func updateCompleteButtonView() {
        completeButtonView.isUserInteractionEnabled = !(UserDefaultManager.shared.projectChapters.count == 0)
        completeButtonView.backgroundColor = completeButtonView.isUserInteractionEnabled ? .appColor(.main) : .appColor(.disable)
    }
    
    // MARK: Initializer
    init(viewModel: ProjectInputDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUI()
        bind(to: viewModel)
        view.backgroundColor = .appColor(.white)
        configureNavigationBar()
        
        completeButtonView.isUserInteractionEnabled = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        viewModel.viewWillAppearRelay.accept(())
        tableView.snp.updateConstraints {
            $0.height.equalTo(CGFloat(UserDefaultManager.shared.projectChapters.count) * tableView.rowHeight)
        }
        updateCompleteButtonView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
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
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "발행하기", backgroundColor: .white))
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

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
    let viewModel: ProjectLookupViewModel
    
    // MARK: - Binding
    func bind(to viewModel: ProjectLookupViewModel) {
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                viewModel.createProject()
            }.disposed(by: disposeBag)
        
        viewModel.lookUpCellDataDriver
            .drive(tableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ProjectChapterLookupCell.self.description(), for: IndexPath(row: row, section: 0)) as? ProjectChapterLookupCell else { return UITableViewCell() }
                cell.bind(to: .init(number: row + 1, title: data))
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { indexPath in
                print(indexPath)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectLookupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
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
        tabBarController?.tabBar.isHidden = true
//        if let navigationController = navigationController as? NavigationController, !viewModel.completeButtonIsHidden {
//            navigationController.updateProgressBar(progress: 1)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UIComponents
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.register(ProjectChapterLookupCell.self, forCellReuseIdentifier: ProjectChapterLookupCell.self.description())
        v.delegate = self
        v.rowHeight = 60
        v.separatorStyle = .none
        return v
    }()
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "발행하기", backgroundColor: .next))
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
        let v = ProjectLookupHeaderView(viewModel: .init(title: "temp", division: "temp", startDateString: "temp", endDateString: "temp"))
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 108
    }
}

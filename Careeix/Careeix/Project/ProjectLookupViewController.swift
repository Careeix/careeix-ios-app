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
enum ProjectViewType {
    case get
    case post
    
    func inset() -> CGFloat {
        switch self {
        case .get:
            return 14
        case .post:
            return 30
        }
    }
    
    func completeButtonIsHidden() -> Bool {
        switch self {
        case .get:
            return true
        case .post:
            return false
        }
    }
}
struct ProjectLookupViewModel {
    let topInset: CGFloat
    let projectId: Int
    let completeButtonIsHidden: Bool
    let lookUpCellDataDriver: Driver<[String]>
    
    init(type: ProjectViewType) {
        self.projectId = UserDefaultManager.shared.currentWritingProjectId
        self.topInset = type.inset()
        lookUpCellDataDriver = .just(UserDefaultManager.shared.projectChapters[projectId]?.map { $0.title } ?? [])
        completeButtonIsHidden = type.completeButtonIsHidden()
    }
    
    func createProject() {
        print("발행전 데이터 확인")
        print(projectId)
        print(UserDefaultManager.shared.jwtToken)
        print(UserDefaultManager.shared.projectInput[projectId])
        print(UserDefaultManager.shared.projectChapters[projectId])
        //        // TODO: 서버 통신
        deleteProject()
    }
    
    func deleteProject() {
        UserDefaultManager.shared.projectInput[projectId] = nil
        UserDefaultManager.shared.projectChapters[projectId] = nil
    }
}

struct ProjectChapterLookupCellViewModel {
    let number: Int
    let title: String
}
class ProjectChapterLookupCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(to viewModel: ProjectChapterLookupCellViewModel) {
        numberLabel.text = "\(viewModel.number)"
        titleLabel.text = viewModel.title
    }
    
    // MARK: - UIComponents
    let numberLabel = UILabel()
    let titleLabel = UILabel()
    
    func setUI() {
        [numberLabel, titleLabel].forEach { contentView.addSubview($0) }
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(numberLabel.snp.trailing).offset(10)
        }
    }
}
class ProjectLookupViewController: UIViewController {
    var disposeBag = DisposeBag()
    let viewModel: ProjectLookupViewModel
    
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
        setupNavigationBackButton()
        setUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tabBarController?.tabBar.isHidden = true
        if let navigationController = navigationController as? NavigationController, !viewModel.completeButtonIsHidden {
            navigationController.updateProgressBar(progress: 1)
        }
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(viewModel.topInset - 15)
        }
        
        completeButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(78)
        }
    }
}
struct ChapterHeaderViewModel {
    let title: String
    let division: String
    let startDateString: String
    let endDateString: String
}
class ChapterHeaderView: UIView {
    let titleLabel: UILabel = {
        let l = UILabel()
        
        return l
    }()
    let descriptionLabel: UILabel = {
        let l = UILabel()
        return l
    }()
    let chapterLabel: UILabel = {
        let l = UILabel()
        l.text = "목차"
        l.textColor = .appColor(.gray300)
        return l
    }()
    func bind(to viewModel: ChapterHeaderViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = "\(viewModel.division) | \(viewModel.startDateString) ~ \(viewModel.endDateString)"
    }
    init(viewModel: ChapterHeaderViewModel) {
        super.init(frame: .zero)
        setUI()
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        [titleLabel, descriptionLabel, chapterLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        chapterLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(37)
            $0.leading.equalTo(titleLabel)
        }
    }
}
extension ProjectLookupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = ChapterHeaderView(viewModel: .init(title: "temp", division: "temp", startDateString: "temp", endDateString: "temp"))
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 108
    }
}

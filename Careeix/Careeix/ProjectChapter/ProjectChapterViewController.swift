//
//  ProjectChapterViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

struct ProjectChapterViewModel {
    
    let titleDriver: Driver<String>
    let chapterTitleDriver: Driver<String>
    let descriptionDriver: Driver<String>
    let noteDriver: Driver<[Note]>
    
    init(title: String, number: Int, projectChapter: ProjectChapter) {
        titleDriver = .just(title)
        chapterTitleDriver = .just("\(number.zeroFillTenDigits())  \(projectChapter.title)")
        descriptionDriver = .just(projectChapter.content)
        noteDriver = .just(projectChapter.notes)
    }
}

class ProjectChapterViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: ProjectChapterViewModel) {
        viewModel.titleDriver
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        viewModel.chapterTitleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.descriptionDriver
            .drive(contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.noteDriver
            .drive(noteTableView.rx.items) { tableView, row, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.self.description(), for: IndexPath(row: row, section: 0)) as? NoteCell else { return UITableViewCell() }
                cell.changeLookupMode()
                cell.setColor(row: row)
                cell.bind(to: .init(inputString: data.content))
                return cell
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectChapterViewModel) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBackButton()
        setUI()
        bind(to: viewModel)
        view.backgroundColor = .appColor(.white)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        noteTableView.snp.updateConstraints {
            $0.height.equalTo(noteTableView.contentSize.height)
        }
    }
    
    // MARK: - UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 18, style: .bold)
        l.textColor = .appColor(.gray700)
        return l
    }()
    let contentLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 13, style: .light)
        l.numberOfLines = 0
        return l
    }()
    let noteTableView: UITableView = {
        let v = UITableView()
        v.estimatedRowHeight = 178
        v.register(NoteCell.self, forCellReuseIdentifier: NoteCell.self.description())
        v.separatorStyle = .none
        v.isScrollEnabled = false
        return v
    }()
}

extension ProjectChapterViewController {
    func setUI() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [titleLabel, contentLabel, noteTableView].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        
        noteTableView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            // TODO: 조정
            $0.height.equalTo(5000)
            $0.bottom.equalToSuperview()
        }
    }
}

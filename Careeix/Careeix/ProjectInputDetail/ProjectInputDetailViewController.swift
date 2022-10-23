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
    
}

class ProjectInputDetailViewController: UIViewController {
    
    init(viewModel: ProjectInputDetailViewModel) {
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
        return tv
    }()
    let addButtonView = ContentsAddButtonView()
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "발행하기", backgroundColor: .disable))
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
            $0.height.equalTo(tableView.contentSize.height)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        addButtonView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(80)
        }
    }
}

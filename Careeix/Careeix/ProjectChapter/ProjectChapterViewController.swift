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
    
    init(title: String, projectChapter: ProjectChapter) {
        // TODO: 서버통신해서 project가져오기
        titleDriver = .just(title)
        chapterTitleDriver = .just(projectChapter.title)
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
        
    }
    
    // MARK: - Initializer
    init(viewModel: ProjectChapterViewModel) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBackButton()
        setUI()
        bind(to: viewModel)
        view.backgroundColor = .appColor(.white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //
    func setUI() {
//        view.addSubview(<#T##view: UIView##UIView#>)
    }
}

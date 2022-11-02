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
//    let project =  BehaviorRelay<Project>
    
    init(projectChapter: ProjectChapter) {
    }
    
}

class ProjectChapterViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Binding
    func bind(to viewModel: ProjectChapterViewModel) {
        
    }
    // MARK: - Initializer
    init(viewModel: ProjectChapterViewModel) {
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

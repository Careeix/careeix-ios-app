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
    let chapterDriver: Driver<ProjectChapter>
    
    init(projectChapter: ProjectChapter) {
        // TODO: 서버통신해서 project가져오기
        chapterDriver = .just(projectChapter)
    }
    
}

class ProjectChapterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

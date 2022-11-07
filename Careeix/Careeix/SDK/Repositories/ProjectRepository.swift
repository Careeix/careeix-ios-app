//
//  File.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

// TODO: API 정의
struct ProjectRepository {
    static func fetchProject(with id: Int) -> Observable<Project> {
        return Observable.create { observer in
            observer.onNext(Project.init(title: "temp", startDateString: "temp", endDateString: "temp", classification: "temp", introduce: "temp", isProceed: false, projectChapters: [.init(title: "", content: "", notes: [])]))
            return Disposables.create()
        }
    }
    
    static func updateProject(with id: Int, project: Project) -> Observable<ProjectDTO.Update.Response> {
        return id == -1
        ? Observable.create { observer in
            observer.onNext(.init(code: "asd", message: "등록"))
            return Disposables.create()
        }
        : Observable.create { observer in
            observer.onNext(.init(code: "asd", message: "수정"))
            return Disposables.create()
        }
    }
}

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
    func fetchProject(with projetId: Int) -> Observable<Project> {
        API<Project>(path: "project/\(projetId)", method: .get, parameters: [:], task: .requestPlain)
            .requestRX()
    }
    
    func updateProject(with id: Int, project: Project) -> Observable<ProjectDTO.Update.Response> {
        print("request:")
        print("id: \(id)")
        dump(project)
        return id == -1
        ? API<ProjectDTO.Update.Response>(path: "project",
                                          method: .post,
                                          parameters: [:],
                                          task: .requestJSONEncodable(project)
        ).requestRX()
            .map { _ in .init(code: "200", message: "성공") }
            .debug("🐷🐷프로젝트 포스트🐷🐷")
            .catch { error in
                if let error = error as? ErrorResponse {
                    return .just(.init(code: error.code, message: error.message))
                } else {
                    return .just(.init(code: "", message: "네트워크 환경을 확인해주세요."))
                }
            }
            
        : Observable.create { observer in
            observer.onNext(.init(code: "asd", message: "수정"))
            return Disposables.create()
        }
    }
}

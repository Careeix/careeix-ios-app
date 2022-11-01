//
//  NetworkService.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/06.
//

import Foundation
import Moya
import CareeixKey
import RxSwift
import RxMoya
enum CustomTask {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestParameters(encoding: ParameterEncoding)
}

struct APIResponse<T: Decodable>: Decodable {
    let code: String
    let data: T?
    let message: String
}

struct ServiceAPI: TargetType {
    var path: String
    var method: Moya.Method
    var parameters: [String: Any]
    var baseURL: URL { return URL(string: CareeixKey.urlString)! }
    var task: Moya.Task
    var headers: [String : String]?
}

class API<T: Decodable> {
    
    let api: ServiceAPI
    private let provider = MoyaProvider<MultiTarget>()

    init(
        path: String,
        method: Moya.Method,
        parameters: [String: Any],
        task: CustomTask,
        headers: [String: String]? = nil
    ) {
        var newTask: Moya.Task = .requestPlain
        switch task {
        case .requestPlain:
            newTask = .requestPlain
        case .requestJSONEncodable(let requestModel):
            newTask = .requestJSONEncodable(requestModel)
        case .requestParameters(let encodingType):
            newTask = .requestParameters(parameters: parameters, encoding: encodingType)
        }
        self.api = .init(path: path, method: method, parameters: parameters, task: newTask, headers: headers)
    }
    
    func requestRX() -> Observable<T>{
        return Observable.create { observer in
            self.request { result in
                switch result {
                case .success(let response):
                    guard let data = response.data else { return }
                    observer.onNext(data)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func request(completion: @escaping (Result<APIResponse<T>, Error>) -> Void) {
        let endpoint = MultiTarget.target(api)
        provider.request(endpoint, completion: { result in
            print("네트워크 통신 결과: ", result)
            switch result {
                
            case .success(let response):
                do {
                    try self.httpProcess(response: response)
                    let data = try response.map(APIResponse<T>.self)
                    completion(.success(data))
                }  catch (let error) {
                    
                    print("디폴트 에러: ", error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("??? 에러: ", error.localizedDescription)
                completion(.failure(error))
            }
        })
    }
    
    private func httpProcess(response: Response) throws {
        guard 200...299 ~= response.statusCode else {
            throw NetworkError.httpStatus(response.statusCode)
        }
    }
}

public enum NetworkError: Error {
    case objectMapping // 데이터 파싱 오류
    case httpStatus(Int) // statusCode 200...299 이 아님
}

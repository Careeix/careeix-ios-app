//
//  UserDefaultManager.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/06.
//

import Foundation
import CareeixKey
import RxSwift
import RxCocoa
import RxRelay
struct UserDefaultManager {
//    static let shared = UserDefaultManager()

//    private init() { }

    @UserDefault(key: CareeixKey.UserDefaultKey.jwtToken, defaultValue: "")
    public static var jwtToken: String
    
    @UserDefault(key: CareeixKey.UserDefaultKey.kakaoAccessToken, defaultValue: "")
    public static var kakaoAccessToken: String
    
    // TODO: - Key로 옮기기
    /// 수정중인 프로젝트 ID를 저장합니다. -2: 없음, -1: 추가, 0 ~ 무한:  프로젝트 아이디
    @UserDefault(key: "writingProjectId", defaultValue: -2)
    public static var writingProjectId: Int
    
    @UserDefault(key: "projectChaptersInputCache", defaultValue: [-1: []])
    public static var projectChaptersInputCache: [Int: [ProjectChapter]]
    
    @UserDefault(key: "projectBaseInputCache", defaultValue: [-1: ProjectBaseInfo.init(title: "", classification: "", introduce: "")])
    public static var projectBaseInputCache: [Int: ProjectBaseInfo]
    
    @UserDefault(key: "userId", defaultValue: 0)
    public static var userId: Int
    
    @UserDefault(key: "loginType", defaultValue: SocialLoginSDK.SocialLoginType.kakao)
    public static var loginType: SocialLoginSDK.SocialLoginType
}

@propertyWrapper
struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    public let storage: UserDefaults

    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    var wrappedValue: T {
        get {
            guard let data = self.storage.object(forKey: key) as? Data else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)

            UserDefaults.standard.set(data, forKey: key)
        }
    }
}



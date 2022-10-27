//
//  SceneDelegate.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/05.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            SocialLoginSDK.setUrl(with: url)
            ? print("url 세팅 성공")
            : print("url 세팅 실패")
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        SocialLoginSDK.initSDK(type: .kakao)
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        // test start
        
//        let twoButtonAlertViewController = TwoButtonAlertViewController(viewModel: .init(type: .askingPublishProject))
//
//        let signUpViewController = UINavigationController(rootViewController: SignUpViewController(viewModel: .init(
//            nickNameInputViewModel: .init(title: "닉네임",
//                                          placeholder: "10자 이내로 한글, 영문, 숫자를 입력해주세요."),
//            jobInputViewModel: .init(title: "직무",
//                                     placeholder: "직무를 입력해주세요.(Ex. 서버 개발자)"),
//            annualInputViewModel: .init(title: "연차",
//                                        contents: ["입문(1년 미만)",
//                                                   "주니어(1~4년차)",
//                                                   "미들(5~8년차)",
//                                                   "시니어(9년차~)"]),
//            detailJobsInputViewModel: .init(title: "상세 직무",
//                                            description: "상세 직무 개수는 1~3개까지 입력 가능합니다.",
//                                            placeholders: Array(repeating: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)",
//                                                                count: 3)),
//            completeButtonViewModel: .init(content: "회원가입", backgroundColor: .disable)
//        )))
//        let homeViewController = UINavigationController(rootViewController: HomeViewController())
//        let projectInputViewController = UINavigationController(rootViewController: ProjectInputViewController(
//            viewModel: .init(
//                titleInputViewModel: .init(title: "제목",
//                                           placeholder: "프로젝트 제목을 입력해주세요."),
//                periodInputViewModel: .init(title: "기간",
//                                            description: "프로젝트 기간을 입력해주세요."),
//                divisionInputViewModel: .init(title: "구분",
//                                              placeholder: "Ex. 개인활동/팀활동/(소속이름)"),
//                introduceInputViewModel: .init(title: "소개",
//                                               baseTextViewModel: .init(placeholder: "진행한 일을 2줄 이내로 소개해주세요."))
//            )
//        ))
//        let projectInputDetailViewController = UINavigationController(rootViewController: ProjectInputDetailViewController(viewModel: .init()))
////        let chapterInputViewController = UINavigationController(rootViewController: ProjectChapterInputViewController(viewModel: .init(currentIndex: <#T##Int#>, titleTextFieldViewModel: <#T##BaseTextFieldViewModel#>, contentViewModel: <#T##BaseTextViewModel#>)))
//        let onboardingViewController = UINavigationController(rootViewController: OnboardViewController())
////        UserDefaultManager.shared.projectChapters = []

        UserDefaultManager.shared.jwtToken = ""
        // test end
        
        
        window?.rootViewController = UserDefaultManager.shared.jwtToken == ""
        ? UINavigationController(rootViewController: ProjectInputDetailViewController(viewModel: .init()))
        : TabBarController()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showTabBarController),
                                               name: Notification.Name("loginSuccess"),
                                               object: nil)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
    
    @objc
    func showTabBarController() {
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
    
    @objc
    func showOnboardController() {
        window?.rootViewController = UINavigationController(rootViewController: OnboardViewController())
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}


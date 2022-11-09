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
            _ = SocialLoginSDK.setUrl(with: url)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        SocialLoginSDK.initSDK(type: .kakao)
        window = UIWindow(windowScene: windowScene)
        
        UserDefaultManager.writingProjectId = -2

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showTabBarController),
                                               name: Notification.Name("loginSuccess"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showOnboardController),
                                               name: Notification.Name("logoutSuccess"),
                                               object: nil)
        
        window?.rootViewController = UserDefaultManager.user.jwt == ""
        ? UINavigationController(rootViewController: OnboardViewController())
        : TabBarController()
        
        window?.backgroundColor = .appColor(.white)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
    
    @objc
    func showTabBarController() {
        window?.rootViewController = TabBarController()
    }
    
    @objc
    func showOnboardController() {
        let vc = OnboardViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc )
        vc.alertSuccessLogout()
    }
    
}


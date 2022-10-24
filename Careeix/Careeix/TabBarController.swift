//
//  TabbarController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/06.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var homeViewController: UIViewController = {
        let vc = UINavigationController(rootViewController: HomeViewController())
        
        vc.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        return vc
    }()
    
    lazy var projectInputViewController: UIViewController = {
        let vc = UIViewController()
        
        vc.tabBarItem = UITabBarItem(title: "등록", image: UIImage(systemName: "trash"), tag: 1)
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [homeViewController, projectInputViewController]
        delegate = self
        tabBar.tintColor = .black
    }
    
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("😱😱😱", tabBarController.selectedViewController)
        if let fromVC = tabBarController.selectedViewController as? UINavigationController{
            print(viewController)
            if viewController.tabBarItem.tag == 1 {
                print("ASd")
                let vc = ProjectInputViewController(
                    viewModel: .init(
                        titleInputViewModel: .init(title: "제목",
                                                   placeholder: "프로젝r트 제목을 입력해주세요."),
                        periodInputViewModel: .init(title: "기간",
                                                    description: "프로젝트 기간을 입력해주세요."),
                        divisionInputViewModel: .init(title: "구분",
                                                      placeholder: "Ex. 개인활동/팀활동/(소속이름)"),
                        introduceInputViewModel: .init(title: "소개",
                                                       placeholder: "진행한 일을 2줄 이내로 소개해주세요.")
                    ))
                if viewController.tabBarItem.tag == 1 {
                    fromVC.pushViewController(vc, animated: true)
                    return false
                }
            }
            return false
        }
        return false
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(viewController)
    }
}

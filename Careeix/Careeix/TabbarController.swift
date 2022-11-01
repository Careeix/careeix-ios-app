//
//  TabbarController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/06.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var homeViewController: UIViewController = {
        let vc = NavigationController(rootViewController: HomeViewController())
        vc.updateProgressBar(progress: 0)
        vc.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
        
        return vc
    }()
    
    lazy var projectInputViewController: UIViewController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "등록", image: UIImage(named: "add"), tag: 1)
        
        return vc
    }()
    
    
    lazy var careerViewController: UIViewController = {
        let vc = NavigationController(rootViewController: UIViewController())
        vc.updateProgressBar(progress: 0)
        vc.tabBarItem = UITabBarItem(title: "커리어", image: UIImage(named: "career"), tag: 2)
        
        return vc
    }()
    
    lazy var myPageViewController: UIViewController = {
        let vc = NavigationController(rootViewController: MyPageViewController())
        vc.updateProgressBar(progress: 0)
        vc.tabBarItem = UITabBarItem(title: "My", image: UIImage(named: "profile"), tag: 3)
        
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [homeViewController, projectInputViewController, careerViewController, myPageViewController]
        delegate = self
        tabBar.tintColor = .black
    }
}
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let fromVC = tabBarController.selectedViewController as? UINavigationController{
            if viewController.tabBarItem.tag == 1 {
                let vc = ProjectInputViewController(
                    viewModel: .init(
                        titleInputViewModel: .init(title: "제목",
                                                   textFieldViewModel: .init(placeholder: "프로젝트 제목을 입력해주세요.")),
                        periodInputViewModel: .init(title: "기간",
                                                    description: "프로젝트 기간을 입력해주세요.",
                                                    checkBoxViewModel: .init()
                                                   ),
                        divisionInputViewModel: .init(title: "구분",
                                                      textFieldViewModel: .init(placeholder: "Ex. 개인활동/팀활동/(소속이름)")),
                        introduceInputViewModel: .init(title: "소개",
                                                       baseTextViewModel: .init(placeholder: "진행한 일을 2줄 이내로 소개해주세요."))
                    )
                )
                fromVC.pushViewController(vc, animated: true)
                return false
            }
        }
        return true
    }
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [homeViewController]
        tabBar.tintColor = .black
    }
    
}

//
//  NavigationController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/31.
//

import UIKit

class NavigationController: UINavigationController {
    var progressBar = UIView()
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.view.addSubview(progressBar)
        progressBar.backgroundColor = .appColor(.main)
        progressBar.snp.makeConstraints {
            $0.leading.equalTo(navigationBar)
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(3)
        }
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgressBar(progress: CGFloat) {
        progressBar.snp.updateConstraints {
            $0.width.equalTo(view.frame.width * progress)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !(viewController is ProjectInputViewController
            || viewController is ProjectInputDetailViewController
            || viewController is ProjectChapterInputViewController
            || viewController is ProjectLookupViewController
            || viewController is ProjectChapterViewController
        ) {
            updateProgressBar(progress: 0)
        }
    }
}

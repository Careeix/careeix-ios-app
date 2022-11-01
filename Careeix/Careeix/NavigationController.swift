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
            $0.center.equalToSuperview()
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
        print("🐿️🐿️🐿️프로그레스바 그릴께요🐿️🐿️", progress)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeViewController {
            updateProgressBar(progress: 0)
        }
        print(viewController,"🐶🐶🐶didshow🐶🐶🐶")
    }
}

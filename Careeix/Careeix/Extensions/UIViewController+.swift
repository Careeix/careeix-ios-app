//
//  UIViewController+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/24.
//

import UIKit

extension UIViewController {

    func configureNavigationBar() {
        // TODO: rootView일 경우 어떻게 없앨 수 있을까 ?
//        print(self, self.navigationController?.viewControllers)
        let backButtonSpacer = UIBarButtonItem()
        backButtonSpacer.width = -28
        let backButton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        navigationItem.setLeftBarButtonItems([backButtonSpacer, backButton], animated: false)
        navigationController?.navigationBar.barTintColor = .appColor(.white)
    }
    @objc
    func didTapBackButton() {
        
        navigationController?.popViewController(animated: true)
    }
}

extension UINavigationController {


    func setProgressBar(view: UIView, from: CGFloat, to: CGFloat) {
        view.backgroundColor = .red
        navigationBar.addSubview(view)

        view.snp.remakeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width * from)
            $0.height.equalTo(3)
        }
        
        navigationBar.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2) {
            view.snp.updateConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width * to)
                self.navigationBar.layoutIfNeeded()
            }
        }
    }
}



//
//  UIViewController+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/24.
//

import UIKit

extension UIViewController {

    func setupNavigationBackButton() {
        let backButtonSpacer = UIBarButtonItem()
        backButtonSpacer.width = -28
        let backButton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapBackButton))
        navigationItem.setLeftBarButtonItems([backButtonSpacer, backButton], animated: false)
    }
    
    @objc
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

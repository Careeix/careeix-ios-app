//
//  MyPageViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/01.
//

import UIKit

class MyPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UIComponents
    let tableView: UIView = {
        let v = UITableView()
        return v
    }()
}

extension MyPageViewController {
    func setUI() {
        view.addSubview(tableView)
    }
}



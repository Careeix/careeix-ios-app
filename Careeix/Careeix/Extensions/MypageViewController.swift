//
//  MypageViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/02.
//

import Foundation
import UIKit
import SnapKit

class MypageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registedTableViewCell()
        configureDelegate()
    }
    let myPageTableView = UITableView(frame: .zero, style: .grouped)
    
    func configureTableView() {
        view.addSubview(myPageTableView)
        myPageTableView.backgroundColor = .appColor(.white)
        myPageTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func registedTableViewCell() {
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "cell")
        myPageTableView.register(MyPageHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    func configureDelegate() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
    }
}

extension MypageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! MyPageHeaderView
        switch section {
        case 0:
            header.title.text = "설정"
            return header
        case 1:
            header.title.text = "서비스 정보"
            return header
        default:
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension MypageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        default:
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPageTableView.dequeueReusableCell(withIdentifier: "cell") as! MyPageTableViewCell
        cell.textLabel?.textColor = .appColor(.gray900)
        cell.textLabel?.font = .pretendardFont(size: 15, style: .light)
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                cell.textLabel?.text = "계정 관리"
                return cell
            default:
                return cell
            }
        } else {
            switch indexPath.item {
            case 0:
                cell.textLabel?.text = "앱 버전 정보"
                return cell
            case 1:
                cell.textLabel?.text = "이용약관"
                return cell
            case 2:
                cell.textLabel?.text = "개인정보처리방침"
                return cell
            case 3:
                cell.textLabel?.text = "Makers"
                return cell
            case 4:
                cell.textLabel?.text = "문의 하기"
                return cell
            case 5:
                cell.textLabel?.text = "로그아웃"
                return cell
            default:
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                let accountInfoVC = AccountInfoViewController()
                self.navigationController?.pushViewController(accountInfoVC, animated: true)
                return print("계정 관리")
            default:
                return
            }
        } else {
            switch indexPath.item {
            case 0:
                return print("앱 버전 정보")
            case 1:
                return print("이용약관")
            case 2:
                return print("개인정보처리방침")
            case 3:
                return print("Makers")
            case 4:
                return print("문의하기")
            case 5:
                return print("로그아웃")
            default:
                return
            }
        }
    }
}

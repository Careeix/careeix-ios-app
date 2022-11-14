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
        registedTableViewCell()
        configureDelegate()
        myPageTableView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
    }
    
    let myPageTableView = UITableView(frame: .zero, style: .insetGrouped)
    
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
            header.titleLabel.text = "설정"
            return header
        case 1:
            header.titleLabel.text = "서비스 정보"
            return header
        default:
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
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
        cell.selectionStyle = .none
        
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
            default:
                return
            }
        } else {
            switch indexPath.item {
            case 0:
                let vc = OneButtonAlertViewController(viewModel: .init(content: "앱 버전은 v1.0.0 입니다.", buttonText: "확인", textColor: .black))
                present(vc, animated: true)
            case 1:
                let vc = WebViewController(linkString: "https://makeus-challenge.notion.site/66c59a11e5c843148d276cfa1fad90dc")
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = WebViewController(linkString: "https://makeus-challenge.notion.site/e7509d429cdb4d408406a014a6ac1e27")
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = WebViewController(linkString: "https://makeus-challenge.notion.site/Team-careeix-9036c323cba141a999ebc74280b3fed2")
                navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = WebViewController(linkString: "https://makeus-challenge.notion.site/753492615dcc4d8a98b5fe2e8b9cc6a4")
                navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = TwoButtonAlertViewController(viewModel: .init(type: .warningLogoutWriting))
                vc.delegate = self
                present(vc, animated: true)
            default:
                return
            }
        }
    }
}

extension MypageViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        UserDefaultManager.user = .init(jwt: "", message: "")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logoutSuccess"), object: nil)
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
    }
}

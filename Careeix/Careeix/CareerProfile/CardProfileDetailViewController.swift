//
//  CardProfileDetailViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/10/21.
//

import Foundation
import UIKit
import SnapKit

class CardProfileDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configurationDatasource()
        setupNavigationBackButton()
        getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    var userId = 0
    
    func getUserData() {
        API<UserModel>(path: "users/profile/\(userId)", method: .get, parameters: [:], task: .requestPlain).request { [weak self] result in
            switch result {
            case .success(let response):
                // data:
                self?.changeDatasource(data: response.data)
            case .failure(let error):
                // alert
                print(error.localizedDescription)
            }
        }
    }
    
    var cardProfileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    private let cardProfileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    func setCollectionView() {
        view.addSubview(cardProfileCollectionView)
        cardProfileCollectionView.collectionViewLayout = createLayout()
        cardProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    enum CardProfileSection: Hashable {
        case userProfile, introduce
    }
    
    enum CardProfileItem: Hashable {
        case userProfile(UserModel), introduce(UserModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>!
    
    func configurationDatasource() {
        let cardProfileRegistraion = UICollectionView.CellRegistration<CardProfileCell, CardProfileItem> { _, _, _ in }
        let introduceRegistration = UICollectionView.CellRegistration<IntroduceCell, CardProfileItem> { _, _, _ in }
        
        datasource = UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>(collectionView: cardProfileCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .userProfile(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cardProfileRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            case .introduce(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: introduceRegistration, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            }
        })
        changeDatasource()
    }
    
    func changeDatasource(data: UserModel? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<CardProfileSection, CardProfileItem>()
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(data ?? cardProfileModel)])
        snapshot.appendSections([.introduce])
        snapshot.appendItems([.introduce(data ?? cardProfileModel)])
        datasource.apply(snapshot)
    }
}

extension CardProfileDetailViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 62, leading: 0, bottom: 0, trailing: 0)
                return section
            case 1:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case 2:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                return section
            case 3:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                return nil
            }
        }
    }
}

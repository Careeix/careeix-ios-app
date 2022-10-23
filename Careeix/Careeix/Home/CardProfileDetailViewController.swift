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
        createNavigationBarItem()
        setCollectionView()
        configurationDatasource()
        tabBarController?.tabBar.isHidden = true
    }
    
    var cardProfileModel: RelevantCareerModel = RelevantCareerModel(profileImage: "", nickname: "", careerName: "", careerGrade: "", detailCareerName: [])
    
    func createNavigationBarItem() {
        let backButtonImageView = UIImage(named: "back")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImageView, style: .plain, target: self, action: #selector(backToPreviousView))
    }
    
    @objc func backToPreviousView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private let cardProfileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    func setCollectionView() {
        view.addSubview(cardProfileCollectionView)
        cardProfileCollectionView.collectionViewLayout = createLayout()
        cardProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    enum CardProfileSection: Hashable {
        case userProfile
    }
    
    enum CardProfileItem: Hashable {
        case userProfile(RelevantCareerModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>!
    
    func configurationDatasource() {
        let cardProfileRegistraion = UICollectionView.CellRegistration<CardProfileCell, CardProfileItem> { _, _, _ in }
        
        datasource = UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>(collectionView: cardProfileCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .userProfile(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cardProfileRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
//            case .RelevantCareerProfiles(let item):
//                let cell = collectionView.dequeueConfiguredReusableCell(using: relevantCareerProfilesRegistraion, for: indexPath, item: itemIdentifier)
//                cell.configure(item)
//                cell.layer.cornerRadius = 10
//                cell.backgroundColor = .orange
//                return cell
            }
        })
        changeDatasource()
    }
    
    func changeDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<CardProfileSection, CardProfileItem>()
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(cardProfileModel)])
//        snapshot.appendSections([.RelevantCareerProfiles])
//        snapshot.appendItems(RelevantCareerModel.releventCareerProfiles.map { .RelevantCareerProfiles($0) })
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
//            case 1:
//                let item = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1))
//                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .estimated(140), subitem: item, count: 3)
//                group.interItemSpacing = .fixed(10)
//                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 10
//                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//                let headerText = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2)), elementKind: RelevantHeaderView.identifier, alignment: .topLeading)
//                section.boundarySupplementaryItems = [headerText]
//                return section
            default:
                return nil
            }
        }
    }
}

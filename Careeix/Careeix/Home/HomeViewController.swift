//
//  OnboardingViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/10/07.
//

import UIKit
import SnapKit

/**
 1. navigationBaritem Image
    - 일단 보류
 2. 간편 커리어 프로필
    - Compositional Layout
        - cell 하나
    - Diffable Datasource
        - 뷰 안에 프로필 이미지, 닉네임, 직무, 연차, 상세 직무 태그
    - Snapshot
 3. 내 직무와 관련된 커리어 프로필
    - Compositional Layout
        - 3x2 그리드
    - Diffable Datasource
        - 직무, 연차, 상세 직무 태그
    - Snapshot
 */

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configurationDatasource()
        createNavigationBarItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showModalView()
    }
    
    func createNavigationBarItem() {
        let logoImageView = UIImage(named: "logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImageView, style: .plain, target: self, action: #selector(moveToHome))
    }
    
    @objc func moveToHome() {
        showModalView()
    }
    
    func showModalView() {
        let modalView: UIViewController = HomeAlertViewController()
        modalView.modalPresentationStyle = .overCurrentContext
        self.present(modalView, animated: true)
    }
    
    private let homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    enum HomeSection: Hashable {
        case minimalCareerProfile, RelevantCareerProfiles
    }
    
    enum HomeItem: Hashable {
        case minimalCareerProfile(CareerModel), RelevantCareerProfiles(RelevantCareerModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    func setupCollectionView() {
        view.addSubview(homeCollectionView)
        homeCollectionView.collectionViewLayout = createLayout()
        homeCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configurationDatasource() {
        let minimalCareerProfileRegistraion = UICollectionView.CellRegistration<MinimalCareerProfileCell, HomeItem> { _, _, _ in }
        let relevantCareerProfilesRegistraion = UICollectionView.CellRegistration<RelevantCareerProfilesCell, HomeItem> { _, _, _ in }
        let relevantHeaderRegistraion = UICollectionView.SupplementaryRegistration<RelevantHeaderView>(elementKind: RelevantHeaderView.identifier) { _, _, _ in }
        
        datasource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: homeCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .minimalCareerProfile(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: minimalCareerProfileRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            case .RelevantCareerProfiles(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: relevantCareerProfilesRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                cell.layer.cornerRadius = 10
                cell.backgroundColor = .orange
                return cell
            }
        })
        
        datasource.supplementaryViewProvider = { homeCollectionView, kind, indexPath in
            let header = self.homeCollectionView.dequeueConfiguredReusableSupplementary(using: relevantHeaderRegistraion, for: indexPath)
            return header
        }
        
        changeDatasource()
    }
    
    func changeDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.minimalCareerProfile])
        snapshot.appendItems(CareerModel.minimalCareerProfile.map { .minimalCareerProfile($0) })
        snapshot.appendSections([.RelevantCareerProfiles])
        snapshot.appendItems(RelevantCareerModel.releventCareerProfiles.map { .RelevantCareerProfiles($0) })
        datasource.apply(snapshot)
    }
}

extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 54, leading: 20, bottom: 45, trailing: 20)
                return section
            case 1:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .estimated(140), subitem: item, count: 3)
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                let headerText = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2)), elementKind: RelevantHeaderView.identifier, alignment: .topLeading)
                section.boundarySupplementaryItems = [headerText]
                return section
            default:
                return nil
            }
        }
    }
}

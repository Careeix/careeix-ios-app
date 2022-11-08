//
//  CardProfileDetailViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/10/21.
//

import Foundation
import UIKit
import SnapKit
import Moya

class CardProfileDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configurationDatasource()
        setupNavigationBackButton()
        getUserData()
        getProjectData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    var userId = 0
    
    func getUserData() {
        API<UserModel>(path: "users/profile/\(userId)", method: .get, parameters: [:], task: .requestPlain)
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data:
                self?.changeDatasource(userData: response.data)
            case .failure(let error):
                // alert
                print("userAPISuccess: \(error.localizedDescription)")
            }
        }
    }
    
    func getProjectData() {
        let parameters = ["id": UserDefaultManager.user.userId]
        API<[ProjectModel]>(path: "project/by-user", method: .get, parameters: parameters, task: .requestParameters(encoding: URLEncoding(destination: .queryString)))
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data
                self?.changeDatasource(projectData: response.data)
            case .failure(let error):
                // alert
                print("projectAPIError: \(error.localizedDescription)")
            }
        }
    }
    
    var cardProfileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    var projectModel: ProjectModel = ProjectModel(project_id: 0, title: "", start_date: "", end_date: "", is_proceed: 0, classification: "", introduction: "")
    
    private let cardProfileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    func setCollectionView() {
        view.addSubview(cardProfileCollectionView)
        cardProfileCollectionView.collectionViewLayout = createLayout()
        cardProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    enum CardProfileSection: Hashable {
        case userProfile, introduce, project
    }
    
    enum CardProfileItem: Hashable {
        case userProfile(UserModel), introduce(UserModel), project(ProjectModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>!
    
    func configurationDatasource() {
        let cardProfileRegistraion = UICollectionView.CellRegistration<CardProfileCell, CardProfileItem> { _, _, _ in }
        let introduceRegistration = UICollectionView.CellRegistration<IntroduceCell, CardProfileItem> { _, _, _ in }
        let projectListRegistration = UICollectionView.CellRegistration<ProjectListCell, CardProfileItem> { _, _, _ in }
        let projectListHeaderRegistraion = UICollectionView.SupplementaryRegistration<ProjectListHeaderView>(elementKind: ProjectListHeaderView.identifier) { _, _, _ in }
        
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
            case .project(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: projectListRegistration, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            }
        })
        
        datasource.supplementaryViewProvider = { cardProfileCollectionView, kind, indexPath in
            let header = self.cardProfileCollectionView.dequeueConfiguredReusableSupplementary(
                using: projectListHeaderRegistraion, for: indexPath)
            return header
        }
        
        changeDatasource()
    }
    
    func changeDatasource(userData: UserModel? = nil, projectData: [ProjectModel]? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<CardProfileSection, CardProfileItem>()
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(userData ?? cardProfileModel)])
        snapshot.appendSections([.introduce])
        snapshot.appendItems([.introduce(userData ?? cardProfileModel)])
        snapshot.appendSections([.project])
        snapshot.appendItems([.project(projectData?[0] ?? projectModel)])
        datasource.apply(snapshot)
    }
}

extension CardProfileDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 화면 전환
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProjectListCell else { return }
        
        if indexPath.section == 2 {
            let vc = ProjectLookupViewController(viewModel: ProjectLookupViewModel(projectId: cell.projectId))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print(cell.projectId)
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
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.1))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.1), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
                return section
            case 2:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.4))
                let group = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalWidth(0.4), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                let headerText = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.2)), elementKind: ProjectListHeaderView.identifier, alignment: .topLeading)
                section.boundarySupplementaryItems = [headerText]
                section.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 16, bottom: 10, trailing: 16)
                return section
            default:
                return nil
            }
        }
    }
}

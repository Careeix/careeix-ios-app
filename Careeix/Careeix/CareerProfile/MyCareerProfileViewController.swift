//
//  MyCareerProfileViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/11/07.
//

import Foundation
import UIKit
import SnapKit
import Moya

class MyCareerProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configurationDatasource()
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileInputView), name: Notification.Name(rawValue: "didTapUpdateProfileImageView"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyProjectData()
    }
    
    @objc func showProfileInputView() {
        let vc = UpdatedNicknameViewController()
        navigationController?.pushViewController(vc, animated: true)
        print("showProfileInputView")
    }

    func getMyProjectData() {
        let parameters = ["id": UserDefaultManager.user.userId]
        API<[ProjectModel]>(path: "project/by-user", method: .get, parameters: parameters, task: .requestParameters(encoding: URLEncoding(destination: .queryString)))
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data
                let user = UserDefaultManager.user
                self?.changeDatasource(userData: .init(
                    userId: user.userId, userJob: user.userJob, userDetailJobs: user.userDetailJobs, userWork: user.userId, userNickname: user.userNickname, userProfileImg: user.userProfileImg, userProfileColor: user.userProfileColor, userIntro: user.userIntro, userSocialProvider: user.userSocialProvider
                ), projectData: response.data ?? [])
            case .failure(let error):
                // alert
                print("projectAPIError: \(error.localizedDescription)")
            }
        }
    }
    
    var profileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    var projectModel: ProjectModel = ProjectModel(project_id: 0, title: "", start_date: "", end_date: "", is_proceed: 0, classification: "", introduction: "")
    
    private let myCareerProfileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    func setCollectionView() {
        view.addSubview(myCareerProfileCollectionView)
        myCareerProfileCollectionView.collectionViewLayout = createLayout()
        myCareerProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
//    func tapUpdateVC() {
//        let profileCell = MyCareerProfileCell()
//
//        profileCell.updateCareerProfileImageView.addGestureRecognizer(tapGesture)
//    }
    
    @objc func moveToUpdatedProfileVC() {
        let vc = UpdatedNicknameViewController()
        present(vc, animated: true)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
    }
 
    enum MyCareerProfileSection: Hashable {
        case userProfile, introduce, project
    }
    
    enum MyCareerProfileItem: Hashable {
        case userProfile(UserModel), introduce(UserModel), project(ProjectModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<MyCareerProfileSection, MyCareerProfileItem>!
    
    func configurationDatasource() {
        let myProfileRegistraion = UICollectionView.CellRegistration<MyCareerProfileCell, MyCareerProfileItem> { _, _, _ in }
        let introduceRegistration = UICollectionView.CellRegistration<MyIntroduceCell, MyCareerProfileItem> { _, _, _ in }
        let projectListRegistration = UICollectionView.CellRegistration<ProjectListCell, MyCareerProfileItem> { _, _, _ in }
        let projectListHeaderRegistraion = UICollectionView.SupplementaryRegistration<ProjectListHeaderView>(elementKind: ProjectListHeaderView.identifier) { _, _, _ in }
        
        datasource = UICollectionViewDiffableDataSource<MyCareerProfileSection, MyCareerProfileItem>(collectionView: myCareerProfileCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .userProfile(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: myProfileRegistraion, for: indexPath, item: itemIdentifier)
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
        
        datasource.supplementaryViewProvider = { myProfileRegistraion, kind, indexPath in
            let header = self.myCareerProfileCollectionView.dequeueConfiguredReusableSupplementary(
                using: projectListHeaderRegistraion, for: indexPath)
            return header
        }
        
        changeDatasource()
    }
    
    func changeDatasource(userData: UserModel? = nil, projectData: [ProjectModel] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<MyCareerProfileSection, MyCareerProfileItem>()
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(userData ?? profileModel)])
        snapshot.appendSections([.introduce])
        snapshot.appendItems([.introduce(userData ?? profileModel)])
        snapshot.appendSections([.project])
        snapshot.appendItems(projectData.compactMap { .project($0)} )
        datasource.apply(snapshot, animatingDifferences: true)
    }
    

}

extension MyCareerProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 화면 전환
        guard let projectCell = collectionView.cellForItem(at: indexPath) as? ProjectListCell else { return }

        if indexPath.section == 2 {
            let vc = ProjectLookupViewController(viewModel: ProjectLookupViewModel(projectId: projectCell.projectId))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("projectId = \(projectCell.projectId)")
    }
    
}

extension MyCareerProfileViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.6))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.6), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
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
                section.interGroupSpacing = 10
                return section
            default:
                return nil
            }
        }
    }
}


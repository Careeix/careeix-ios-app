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
        configurationDatasource()
        setCollectionView()
        observingNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyUserData()
        getMyProjectData()
    }
    
    func observingNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileInputView), name: Notification.Name(rawValue: "didTapUpdateProfileImageView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProjectInputView), name: Notification.Name(rawValue: "didTapKebabImageView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUpdateInputView), name: Notification.Name(rawValue: "didTapUpdateButtonView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDeleteModalView), name: Notification.Name(rawValue: "didTapDeleteButtonView"), object: nil)
    }
    
    @objc func showProfileInputView() {
//        let vc = UpdatedMyProfileViewController()
//        navigationController?.pushViewController(vc, animated: true)
        print("🙆‍♂️🙆‍♂️🙆‍♂️showProfileInputView")
    }
    
    @objc func showProjectInputView() {
//        let vc = UpdatedMyProfileViewController()
//        navigationController?.pushViewController(vc, animated: true)
        print("🤷‍♂️🤷‍♂️🤷‍♂️showProjectInputView")
    }
    
    @objc func showUpdateInputView() {
        print("🤗🤗🤗showUpdateInputView Tapped!!!!")
    }
    
    @objc func showDeleteModalView() {
        print("🤔🤗🤗showDeleteModalView Tapped!!!!")
    }
    
    func getMyUserData() {
        let user = UserDefaultManager.user
        updateUserSection(userData: .init(userId: user.userId,
                                          userJob: user.userJob,
                                          userDetailJobs: user.userDetailJobs,
                                          userWork: user.userWork,
                                          userNickname: user.userNickname,
                                          userProfileImg: user.userProfileImg,
                                          userProfileColor: user.userProfileColor,
                                          userIntro: user.userIntro,
                                          userSocialProvider: user.userSocialProvider))
    }
    
    func getMyProjectData() {
        let parameters = ["id": UserDefaultManager.user.userId]
        API<[ProjectModel]>(path: "project/by-user", method: .get, parameters: parameters, task: .requestParameters(encoding: URLEncoding(destination: .queryString)))
            .request { [weak self] result in
                switch result {
                case .success(let response):
                    // data
                    self?.updateProjectSection(projectData: response.data ?? [])
                    
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
        myCareerProfileCollectionView.delegate = self
        myCareerProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func moveToUpdatedProfileVC() {
        let vc = UpdatedNicknameViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateProjectSection(projectData: [ProjectModel] = []) {
        var snapshot = datasource.snapshot(for: .project)
        snapshot.deleteAll()
        snapshot.append(projectData.compactMap { .project($0)})
        datasource.apply(snapshot, to: .project)
    }
    
    func updateUserSection(userData: UserModel? = nil) {
        var snapshot = datasource.snapshot(for: .userProfile)
        snapshot.deleteAll()
        snapshot.append([.userProfile(userData ?? profileModel)])
        datasource.apply(snapshot, to: .userProfile)
    }
    
}

extension MyCareerProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 화면 전환
        guard let projectCell = collectionView.cellForItem(at: indexPath) as? ProjectListCell else { return }
        
        if indexPath.section == 2 {
            let vc = ProjectLookupViewController(viewModel: ProjectLookupViewModel(projectId: projectCell.projectId))
            self.navigationController?.pushViewController(vc, animated: true)
            print("projectId = \(projectCell.projectId)")
        }
        
    }
    
}

extension MyCareerProfileViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.55))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.55), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
                return section
            case 1:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalWidth(0.2))
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalWidth(0.2), subitem: item, count: 1)
                let section = NSCollectionLayoutSection(group: group)
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

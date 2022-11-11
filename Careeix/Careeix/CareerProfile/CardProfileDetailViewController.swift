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

enum CardProfileSection: Hashable {
    case userProfile, introduce, project
}

enum CardProfileItem: Hashable {
    case userProfile(UserModel), introduce(UserModel), project(ProjectModel)
}

class CardProfileDetailViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configurationDatasource()
        setupNavigationBackButton()
        getUserData()
        getProjectData()
        setEmptyProject()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observingNotificationCenter()
    }
    
    var userId = 0
    
    let emptyContentView = UIView()
    
    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .appColor(.gray30)
        imageView.image = UIImage(named: "emptyProject")
        return imageView
    }()
    
    let largeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray200)
        label.font = .pretendardFont(size: 15, style: .medium)
        label.textAlignment = .center
        label.text = "프로젝트가 존재하지 않습니다."
        return label
    }()
    
    let smallLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.gray200)
        label.font = .pretendardFont(size: 14, style: .medium)
        label.textAlignment = .center
        label.text = "하단의 등록을 눌러 프로젝트를 추가해보세요."
        return label
    }()
    
    func setEmptyProject() {
        view.addSubview(emptyContentView)
        
        emptyContentView.isHidden = true
        
        emptyContentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [emptyImageView, largeLabel, smallLabel].forEach { emptyContentView.addSubview($0) }
        
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        largeLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        smallLabel.snp.makeConstraints {
            $0.top.equalTo(largeLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func getUserData() {
        API<UserModel>(path: "users/profile/\(userId)", method: .get, parameters: [:], task: .requestPlain)
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data:
                self?.updateUserSection(userData: response.data)
            case .failure(let error):
                // alert
                print("userAPISuccess: \(error.localizedDescription)")
            }
        }
    }
    
    func getProjectData() {
        let parameters = ["id": userId]
        API<[ProjectModel]>(path: "project/by-user", method: .get, parameters: parameters, task: .requestParameters(encoding: URLEncoding(destination: .queryString)))
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data
                if response.data == [] {
                    self?.emptyContentView.isHidden = false
                    self?.updateProjectSection(projectData: [])
                } else {
                    self?.emptyContentView.isHidden = true
                    self?.updateProjectSection(projectData: response.data ?? [])
                }
            case .failure(let error):
                // alert
                print("projectAPIError: \(error.localizedDescription)")
            }
        }
    }
    
    func observingNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showUserReportModalView), name: Notification.Name(rawValue: "tappedUserReportImageView"), object: nil)
    }
    
    @objc func showUserReportModalView() {
        print("showUserReportModalView Tapped!!!")
//        let reportAlertView = TwoButtonAlertViewController(viewModel: .init(type: .userReportwarning))
//        present(reportAlertView, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "tappedUserReportImageView"), object: nil)
    }
    
    var cardProfileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: nil, userSocialProvider: 0)
    
    var projectModel: ProjectModel = ProjectModel(project_id: 0, title: "", start_date: "", end_date: "", is_proceed: 0, classification: "", introduction: "")
    
    private let cardProfileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    func setCollectionView() {
        view.addSubview(cardProfileCollectionView)
        cardProfileCollectionView.delegate = self
        cardProfileCollectionView.collectionViewLayout = createLayout()
        cardProfileCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    var datasource: UICollectionViewDiffableDataSource<CardProfileSection, CardProfileItem>!
    
    func configurationDatasource() {
        let cardProfileRegistraion = UICollectionView.CellRegistration<CardProfileCell, CardProfileItem> { _, _, _ in }
        let introduceRegistration = UICollectionView.CellRegistration<IntroduceCell, CardProfileItem> { _, _, _ in }
        let projectListRegistration = UICollectionView.CellRegistration<OtherUserProjectListCell, CardProfileItem> { _, _, _ in }
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
    
    func changeDatasource(userData: UserModel? = nil, projectData: [ProjectModel] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<CardProfileSection, CardProfileItem>()
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(userData ?? cardProfileModel)])
        snapshot.appendSections([.introduce])
        snapshot.appendItems([.introduce(userData ?? cardProfileModel)])
        snapshot.appendSections([.project])
        snapshot.appendItems( projectData.compactMap { .project($0)})
        datasource.apply(snapshot)
    }
    
    func updateUserSection(userData: UserModel? = nil) {
        var userDataSnapshot = datasource.snapshot(for: .userProfile)
        var userIntroSnapshot = datasource.snapshot(for: .introduce)
        userDataSnapshot.deleteAll()
        userIntroSnapshot.deleteAll()
        userDataSnapshot.append([.userProfile(userData ?? cardProfileModel)])
        userIntroSnapshot.append([.introduce(userData ?? cardProfileModel)])
        datasource.apply(userDataSnapshot, to: .userProfile)
        datasource.apply(userIntroSnapshot, to: .introduce)
    }
    
    func updateProjectSection(projectData: [ProjectModel] = []) {
        var snapshot = datasource.snapshot(for: .project)
        snapshot.deleteAll()
        snapshot.append(projectData.compactMap { .project($0)})
        datasource.apply(snapshot, to: .project)
    }
}

extension CardProfileDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 화면 전환
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? OtherUserProjectListCell else { return }
        
        if indexPath.section == 2 {
            let vc = ProjectLookupViewController(viewModel: ProjectLookupViewModel(projectId: cell.projectId))
            self.navigationController?.pushViewController(vc, animated: true)
            print(cell.projectId)
        }
        
    }
}

extension CardProfileDetailViewController {
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

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
        homeCollectionView.delegate = self
//        showModalView()
        getUserData()
        recommandUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showModalView()
    }
    
    // MARK: MyCareerProfile API Call
    
    func getUserData() {
        API<UserModel>(path: "users/profile/\(UserDefaultManager.user.userId)", method: .get, parameters: [:], task: .requestPlain)
            .request { [weak self] result in
                print(result)
            switch result {
            case .success(let response):
                // data:
                self?.changeDatasource(myProfileData: response.data)
            case .failure(let error):
                // alert
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: RecommandCareerProfile API Call
    
    func recommandUserData() {
        API<[UserModel]>(path: "users/recommend/profile", method: .get, parameters: [:], task: .requestPlain, headers: ["X-ACCESS-TOKEN": UserDefaultManager.user.jwt])
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data:
                self?.changeDatasource(cardProfileData: response.data)
            case .failure(let error):
                // alert
                print("recommandUserData: \(error.localizedDescription)")
            }
        }
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
        modalView.modalTransitionStyle = .crossDissolve
        self.present(modalView, animated: true)
    }
    
    private let homeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    enum HomeSection: Hashable {
        case myCareerProfile, cardCareerProfiles
    }
    
    enum HomeItem: Hashable {
        case myCareerProfile(UserModel), cardCareerProfiles(UserModel)
    }
    
    var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    func setupCollectionView() {
        view.addSubview(homeCollectionView)
        homeCollectionView.collectionViewLayout = createLayout()
        homeCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    var profileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    var recommandProfileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    func configurationDatasource() {
        let myCareerProfileRegistraion = UICollectionView.CellRegistration<MinimalCareerProfileCell, HomeItem> { _, _, _ in }
        let cardCareerProfilesRegistraion = UICollectionView.CellRegistration<RelevantCareerProfilesCell, HomeItem> { _, _, _ in }
        let relevantHeaderRegistraion = UICollectionView.SupplementaryRegistration<RelevantHeaderView>(elementKind: RelevantHeaderView.identifier) { _, _, _ in }
        
        datasource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(collectionView: homeCollectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .myCareerProfile(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: myCareerProfileRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            case .cardCareerProfiles(let item):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cardCareerProfilesRegistraion, for: indexPath, item: itemIdentifier)
                cell.configure(item)
                return cell
            }
        })
        
        datasource.supplementaryViewProvider = { homeCollectionView, kind, indexPath in
            let header = self.homeCollectionView.dequeueConfiguredReusableSupplementary(
                using: relevantHeaderRegistraion, for: indexPath)
            return header
        }
        
        changeDatasource()
    }
    
    func changeDatasource(myProfileData: UserModel? = nil, cardProfileData: [UserModel]? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.myCareerProfile])
        snapshot.appendItems([.myCareerProfile(myProfileData ?? profileModel)])
        snapshot.appendSections([.cardCareerProfiles])
        snapshot.appendItems([.cardCareerProfiles(cardProfileData?[0] ?? recommandProfileModel)])
        datasource.apply(snapshot)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            // TODO: 화면전환
            
           guard let cell = collectionView.cellForItem(at: indexPath) as? RelevantCareerProfilesCell else { return }
            let vc = CardProfileDetailViewController()
            vc.userId = cell.userId
            self.navigationController?.pushViewController(vc, animated: true)
            print("cell's userId: \(cell.userId)")
        }
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 62, leading: 20, bottom: 20, trailing: 20)
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

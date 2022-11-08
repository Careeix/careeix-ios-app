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
enum GradientColor: String {
    case skyblue = "#8DB8DF"
    case pink = "#E9A6C6"
    case yellow = "#E8CD44"
    case purple = "#A5ADF5"
    case orange = "#F0B782"
    case green = "#699D84"

    func startColor() -> AssetsColor {
        switch self {
        case .skyblue:
            return .skyblueGradientSP
        case .pink:
            return .pinkGradientSP
        case .yellow:
            return .yellowGradientSP
        case .purple:
            return .purpleGradientSP
        case .orange:
            return .orangeGradientSP
        case .green:
            return .greenGradientSP
        }
    }
    func endColor() -> AssetsColor {
        switch self {
        case .skyblue:
            return .skyblueGradientEP
        case .pink:
            return .pinkGradientEP
        case .yellow:
            return .yellowGradientEP
        case .purple:
            return .purpleGradientEP
        case .orange:
            return .orangeGradientEP
        case .green:
            return .greenGradientEP
        }
    }

    func setGradient(contentView: UIView, cornerRadius: CGFloat = 0) {
        contentView.layer.sublayers?.compactMap { $0 as? CAGradientLayer }.forEach {
            $0.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        print("😡😡😡😡", contentView.bounds)
        let startPoint: UIColor = .appColor(startColor())
        let endPoint: UIColor = .appColor(endColor())
        gradientLayer.colors = [startPoint.cgColor, endPoint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.7)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.2)
        gradientLayer.cornerRadius = cornerRadius
        contentView.layer.addSublayer(gradientLayer)
    }
    
    
}
enum HomeSection: Hashable {
    case myCareerProfile, cardCareerProfiles
}

enum HomeItem: Hashable {
    case myCareerProfile(UserModel), cardCareerProfiles(RecommandUserModel)
}

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configurationDatasource()
        createNavigationBarItem()
        homeCollectionView.delegate = self
        getUserData()
        recommandUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        !UserDefaultManager.firstLoginFlag ? showModalView() : nil
        UserDefaultManager.firstLoginFlag = true
    }
    // MARK: RecommandCareerProfile API Call
    func getUserData() {
        let user = UserDefaultManager.user
        updateMyCareerProfileSection(myProfileData: .init(userId: user.userId,
                                                          userJob: user.userJob,
                                                          userDetailJobs: user.userDetailJobs,
                                                          userWork: user.userWork,
                                                          userNickname: user.userNickname,
                                                          userProfileImg: user.userProfileImg,
                                                          userProfileColor: user.userProfileColor,
                                                          userIntro: user.userIntro,
                                                          userSocialProvider: user.userSocialProvider))

    }
    func recommandUserData() {
        API<[RecommandUserModel]>(path: "users/recommend/profile", method: .get, parameters: [:], task: .requestPlain)
            .request { [weak self] result in
            switch result {
            case .success(let response):
                // data:
                self?.updateCardCareerSection(cardProfileData: response.data ?? [])
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

    var datasource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    
    func setupCollectionView() {
        view.addSubview(homeCollectionView)
        homeCollectionView.collectionViewLayout = createLayout()
        homeCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    var profileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: "", userSocialProvider: 0)
    
    var recommandProfileModel: RecommandUserModel = RecommandUserModel(userDetailJobs: [""], userId: 0, userJob: "", userProfileColor: "", userWork: 0)
    
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
    
    func changeDatasource(myProfileData: UserModel? = nil, cardProfileData: [RecommandUserModel] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.myCareerProfile])
        snapshot.appendItems([.myCareerProfile(myProfileData ?? profileModel)])
        snapshot.appendSections([.cardCareerProfiles])
        snapshot.appendItems(cardProfileData.map { .cardCareerProfiles($0) })
        datasource.apply(snapshot)
    }
    

    
    func updateMyCareerProfileSection(myProfileData: UserModel? = nil) {
        var snapshot = datasource.snapshot(for: .myCareerProfile)
        snapshot.deleteAll()
        snapshot.append([.myCareerProfile(myProfileData ?? profileModel)])
        print(myProfileData, "🧶🧶🧶")
        datasource.apply(snapshot, to: .myCareerProfile)
    }
    func updateCardCareerSection(cardProfileData: [RecommandUserModel] = []) {
        var snapshot = datasource.snapshot(for: .cardCareerProfiles)
        snapshot.deleteAll()
        snapshot.append(cardProfileData.map { .cardCareerProfiles($0) })
        datasource.apply(snapshot, to: .cardCareerProfiles)
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

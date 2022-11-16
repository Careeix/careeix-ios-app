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

enum MyCareerProfileSection: Hashable {
    case userProfile, introduce, project
}

enum MyCareerProfileItem: Hashable {
    case userProfile(UserModel), introduce(UserModel), project(ProjectModel)
}

class MyCareerProfileViewController: UIViewController {
    var prevDropDownView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        observingNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationDatasource()
        getMyUserData()
        getMyProjectData()
        setEmptyProject()
        prevDropDownView?.isHidden = true
        
    }
    
    weak var delegate: TwoButtonAlertViewDelegate?
    var cellProjectId: Int = -1

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
            $0.top.equalToSuperview().offset(250)
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
    
    func observingNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(showDropDownView), name: Notification.Name(rawValue: "didTapKebabImageView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileInputView), name: Notification.Name(rawValue: "didTapUpdateProfileImageView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUpdateInputView), name: Notification.Name(rawValue: "didTapUpdateButtonView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDeleteModalView), name: Notification.Name(rawValue: "didTapDeleteButtonView"), object: nil)
    }
    
    @objc func showDropDownView(_ sender: Notification) {
        guard let v = sender.userInfo?["view"] as? UIView else { return }
        v.isHidden = !v.isHidden
        if prevDropDownView != v {
            prevDropDownView?.isHidden = true
            prevDropDownView = v
        }
    }
    
    @objc func showProfileInputView() {
        let vc = UpdateProfileViewController(
            viewModel: .init(
                jobInputViewModel: .init(title: "직무", textFieldViewModel: .init(placeholder: "직무를 입력해주세요.(Ex. 서버 개발자)")),
                annualInputViewModel: .init(title: "연차",
                                            contents: ["입문(1년 미만)",
                                                       "주니어(1~4년차)",
                                                       "미들(5~8년차)",
                                                       "시니어(9년차~)",
                                                       "선택 안함"]),
                detailJobsInputViewModel: .init(title: "상세 직무 태그",
                                                description: "상세 직무 개수는 1~3개까지 입력 가능합니다.",
                textFieldViewModels: [
                    BaseTextFieldViewModel.init(placeholder: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)"),
                    BaseTextFieldViewModel.init(placeholder: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)"),
                    BaseTextFieldViewModel.init(placeholder: "상세 직무 태그를 입력해주세요.(Ex. UX디자인)")
                ]),
                
                introduceInputViewModel: .init(title: "소개", baseTextViewModel: .init(placeholder: "소개글을 작성해주세요.(55자 이내)", inputStringRelay: .init(value: "소개"))),
                completeButtonViewModel: .init(content: "저장하기", backgroundColor: .next)
            )
        )
        navigationController?.pushViewController(vc, animated: true)
        print("showProfileInputView")
    }
    
    @objc func showUpdateInputView(_ sender: Notification) {
        guard let projectId = sender.userInfo?["projectId"] as? Int else { return }
        let vc = ProjectInputViewController(
            viewModel: .init(
                titleInputViewModel: .init(title: "제목",
                                           textFieldViewModel: .init(placeholder: "프로젝트 제목을 입력해주세요. (25자 이내)")),
                periodInputViewModel: .init(title: "기간",
                                            description: "프로젝트 기간을 입력해주세요.",
                                            checkBoxViewModel: .init()
                                           ),
                classificationInputViewModel: .init(title: "구분",
                                              textFieldViewModel: .init(placeholder: "Ex. 개인활동/팀활동/(소속이름)")),
                introduceInputViewModel: .init(title: "소개",
                                               baseTextViewModel: .init(placeholder: "진행한 일을 2줄 이내로 소개해주세요."))
                ,projectId: projectId
            )
        )
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func showDeleteModalView(_ sender: Notification) {
        let projectDeleteAlertView = TwoButtonAlertViewController(viewModel: .init(type: .deleteProject))
        self.present(projectDeleteAlertView, animated: true)
        projectDeleteAlertView.delegate = self
        guard let projectId = sender.userInfo?["projectId"] as? Int else { return }
        cellProjectId = projectId
        
        print("showDeleteModalView - projectId: \(cellProjectId)")
        
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
    
    var cellData: [ProjectModel]?
    
    func getMyProjectData() {
        let parameters = ["id": UserDefaultManager.user.userId]
        API<[ProjectModel]>(path: "project/by-user", method: .get, parameters: parameters, task: .requestParameters(encoding: URLEncoding(destination: .queryString)))
            .request { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    self.cellData = response.data
                    guard let data = response.data else { return }
                    // data
                    self.updateProjectSection(projectData: data)
                case .failure(let error):
                    // alert
                    print("projectAPIError: \(error.localizedDescription)")
                }
            }
    }
    
    func deleteProjectData() {
        API<String>(path: "project/\(cellProjectId)", method: .patch, parameters: [:], task: .requestPlain).request { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                let deleteProjectConfirmAlertView = OneButtonAlertViewController(viewModel: .init(content: "프로젝트가 삭제되었습니다.", buttonText: "확인", textColor: .gray400))
                
                UserDefaultManager.projectChaptersInputCache[self.cellProjectId] = nil
                UserDefaultManager.projectBaseInputCache[self.cellProjectId] = nil
                
                self.present(deleteProjectConfirmAlertView, animated: true)
                guard let shouldDeleteIndex  = self.cellData?.compactMap({ $0.project_id }).firstIndex(of: self.cellProjectId) else { return }
                self.cellData?.remove(at: shouldDeleteIndex)
                self.updateProjectSection(projectData: self.cellData ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
      
    var profileModel: UserModel = UserModel(userId: 0, userJob: "", userDetailJobs: [""], userWork: 0, userNickname: "", userProfileImg: "", userProfileColor: "", userIntro: nil, userSocialProvider: 0)
    
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
                cell.projectId = item.project_id
                cell.cellItem = indexPath.item
                print("🐉cell.cellItem: \(cell.cellItem)")
                print("🐓indexPath: \(indexPath)")
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
        emptyContentView.isHidden = !projectData.isEmpty
        myCareerProfileCollectionView.isScrollEnabled = !projectData.isEmpty
        snapshot.appendSections([.userProfile])
        snapshot.appendItems([.userProfile(userData ?? profileModel)])
        snapshot.appendSections([.introduce])
        snapshot.appendItems([.introduce(userData ?? profileModel)])
        snapshot.appendSections([.project])
        snapshot.appendItems(projectData.compactMap { .project($0) })
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateUserSection(userData: UserModel? = nil) {
        var userDataSnapshot = datasource.snapshot(for: .userProfile)
        var userIntroSnapshot = datasource.snapshot(for: .introduce)
        userDataSnapshot.deleteAll()
        userIntroSnapshot.deleteAll()
        userDataSnapshot.append([.userProfile(userData ?? profileModel)])
        userIntroSnapshot.append([.introduce(userData ?? profileModel)])
        datasource.apply(userDataSnapshot, to: .userProfile)
        datasource.apply(userIntroSnapshot, to: .introduce)
    }
 
    func updateProjectSection(projectData: [ProjectModel] = []) {
        emptyContentView.isHidden = !projectData.isEmpty
        myCareerProfileCollectionView.isScrollEnabled = !projectData.isEmpty
        var snapshot = datasource.snapshot(for: .project)
        snapshot.deleteAll()
        snapshot.append(projectData.compactMap { .project($0) })
        datasource.apply(snapshot, to: .project)
        
        
        
    }
}

extension MyCareerProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
//        // TODO: 화면 전환
        guard let projectCell = collectionView.cellForItem(at: indexPath) as? ProjectListCell else { return }
        if indexPath.section == 2 {
            let vc = ProjectLookupViewController(viewModel: ProjectLookupViewModel(projectId: projectCell.projectId))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MyCareerProfileViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        deleteProjectData()
        dismiss(animated: true)
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        tabBarController?.tabBar.isHidden = false
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

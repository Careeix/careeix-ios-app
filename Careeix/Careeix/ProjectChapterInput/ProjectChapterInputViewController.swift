//
//  ProjectChapterInputViewModel.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxKeyboard
class ProjectChapterInputViewModel {
    
    var noteCellViewModels: [NoteCellViewModel] = [] {
        didSet {
//            cellDataRelay.accept([])
            cellDataRelay.accept(noteCellViewModels)
        }
    }
    let currentIndex: Int
    
    // MARK: Input
    let cellDataRelay = BehaviorRelay<[NoteCellViewModel]>(value: [])
    let noteTableViewHeightRelay = PublishRelay<CGFloat>()
    let titleStringRelay = PublishRelay<String>()
    let contentStringRelay = PublishRelay<String>()
    let scrollToHeightRelay = PublishRelay<CGFloat>()
    //    let completeTrigger = PublishRelay<Void>()
    // MARK: Output
    let cellDataDriver: Driver<[NoteCellViewModel]>
    let canAddNoteDriver: Driver<Bool>
    let noteTableViewHeightDriver: Driver<CGFloat>
    let scrollToHeightDriver: Driver<CGFloat>
//    let notes: Driver<[String]>
    init(currentIndex: Int) {
        let combinedInputValuesObservable = Observable.combineLatest(titleStringRelay, contentStringRelay) { ($0, $1) }
        combinedInputValuesObservable.subscribe {
            print($0, $1)
        }
        self.currentIndex = currentIndex
        let cellDataRelayShare = cellDataRelay.share()
        cellDataDriver = cellDataRelayShare.asDriver(onErrorJustReturn: [])
        
        canAddNoteDriver = cellDataRelayShare.map { $0.count }
            .do { print($0) }
            .map { $0 < 3 }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
        
        noteTableViewHeightDriver = noteTableViewHeightRelay
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
        
        scrollToHeightDriver = scrollToHeightRelay
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
        
//        notes = Observable.combineLatest(cellDataRelay.value.compactMap { $0.inputStringRelay } )
//            .asDriver(onErrorJustReturn: [])
//        notes = Observable.combineLatest(noteCellViewModels.map({ $0.inputStringRelay
//        })).asDriver(onErrorJustReturn: [])
        //            .asDriver(onErrorJustReturn: [])
    }
}

class ProjectChapterInputViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProjectChapterInputViewModel
    var willDeletedIndex: Int!
    // MARK: Binding
    func bind(to viewModel: ProjectChapterInputViewModel) {
        print("이게 왜불려")
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.contentView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                owner.completeButtonView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
                }
                UIView.animate(withDuration: 0.4) {
                    owner.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .bind(to: viewModel.titleStringRelay)
            .disposed(by: disposeBag)
        
        contentTextView.rx.text.orEmpty
            .bind(to: viewModel.contentStringRelay)
            .disposed(by: disposeBag)
        
        addNoteButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.addNoteCell()
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.didTapCompleteButtonView()
            }.disposed(by: disposeBag)
        
        viewModel.cellDataDriver
            .drive(noteTableView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: NoteCell.self.description(), for: IndexPath(row: row, section: 0)) as? NoteCell else { return UITableViewCell() }
                cell.textView.delegate = self
                let text = viewModel.noteCellViewModels[row].inputStringRelay.value
                cell.viewModel = viewModel.noteCellViewModels[row]
                cell.textView.text = text
                cell.textView.rx.tapGesture()
                    .when(.recognized)
                    .withUnretained(self)
                    .bind { owner, _ in
                        print("셀 텍스트 뷰 클릭됐어 ! 궁극의 위치가 필요해 스크롤 릴레이로 보내야해", row)
                    }.disposed(by: self.disposeBag)
                
                cell.deleteButtonImageView
                    .rx.tapGesture()
                    .when(.recognized)
                    .withUnretained(self)
                    .bind { owner, _ in
                        owner.willDeletedIndex = row
                        owner.showDeleteNoteWarningAlert()
                    }.disposed(by: self.disposeBag)
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.noteTableViewHeightDriver
            .drive(with: self) { owner, height in
                owner.noteTableView.snp.updateConstraints {
                    $0.height.equalTo(height + 10)
                }
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }.disposed(by: disposeBag)
        
        viewModel.canAddNoteDriver
            .drive(with: self) { owner, canAddNote in
                owner.setAddButtonViewState(with: canAddNote)
            }.disposed(by: disposeBag)
        
        noteTableView.rx.itemSelected
            .debug("셀셀셀😎😎😎")
            .compactMap(noteTableView.cellForRow(at:))
            .map { $0.frame }
            .distinctUntilChanged()
            .bind { frame in
                print("선택한 셀의 프레임이에요 궁극의 프레임을 따서 스크롤 위치값을 변경합시다.", frame)
            }.disposed(by: disposeBag)
        
       
//        viewModel.notes
//            .debug("🤯🤯🤯노트들🤯🤯🤯")
//            .drive { a in
//                print(a)
//            }.disposed(by: disposeBag)
    }
    // MARK: Function
    func showDeleteNoteWarningAlert() {
        let alert = TwoButtonAlertViewController(viewModel: .init(content: "NOTE를 삭제하시겠습니까?",
                                                                  leftString: "취소",
                                                                  leftColor: .gray400,
                                                                  rightString: "삭제",
                                                                  rightColor: .error))
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        alert.delegate = self
        
        present(alert, animated: true)
    }
    func setAddButtonViewState(with canAddNote: Bool) {
        addNoteButtonView.enableView.isHidden = !canAddNote
        addNoteButtonView.disableView.isHidden = canAddNote
        addNoteButtonView.isUserInteractionEnabled = canAddNote
    }
    func updateTableViewHeight() {
        let tableViewHeight: CGFloat = noteTableView.visibleCells
            .map { $0.frame.height }
            .reduce(0) { $0 + $1 }
        
        viewModel.noteTableViewHeightRelay
            .accept(tableViewHeight)
            
//        noteTableView.visibleCells
//            .compactMap { $0 as? NoteCell }
//            .enumerated()
//            .forEach { index, cell in
//                print("\(index)번째 노트의 내용: ", cell.viewModel?.inputStringRelay.value)
//            }
    }
    func addNoteCell() {
        print("노트 추가하는 함수가 호출되었어요")
        view.endEditing(false)
        viewModel.noteCellViewModels.append(.init(inputStringRelay: BehaviorRelay<String>(value: ""), row: viewModel.noteCellViewModels.count))
        
        updateTableViewHeight()
        
//        guard let cell = noteTableView.cellForRow(at: IndexPath(row: viewModel.noteCellViewModels.count - 1, section: 0)) as? NoteCell else {
//            return }
//        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom + 50)
//        scrollView.setContentOffset(bottomOffset, animated: false)
//        cell.textView.becomeFirstResponder()
    }
    func didTapCompleteButtonView() {
        print("저장 버튼이 눌렸어요")
        updateProjectChapter()
    }
    
    func updateProjectChapter() {
        guard let title = titleTextField.text, let content = contentTextView.text else {
            print("제목 또는 내용이 nil이에요")
            return
        }
        if viewModel.currentIndex == UserDefaultManager.shared.projectChapters.count {
            print("메모 업데이트 성공")
            UserDefaultManager.shared.projectChapters.append(.init(title: title, content: content, notes: []))
        }
    }
    
    func checkAndRemove() {
        if viewModel.currentIndex < UserDefaultManager.shared.projectChapters.count {
            let currentChapter = UserDefaultManager.shared.projectChapters[viewModel.currentIndex]
            if currentChapter.content == ""
                && currentChapter.title == ""
                && currentChapter.notes.filter({ $0 != "" }).count == 0 {
                UserDefaultManager.shared.projectChapters.remove(at: viewModel.currentIndex)
            }
        }
    }
    func fillInputs() {
        if viewModel.currentIndex < UserDefaultManager.shared.projectChapters.count {
            print("아래 내용을 채워야해요")
            print(UserDefaultManager.shared.projectChapters[viewModel.currentIndex])
        }
    }
    
    // MARK: Initializer
    init(viewModel: ProjectChapterInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        
        setUI()
        title = "\(viewModel.currentIndex)"
        completeButtonView.isUserInteractionEnabled = false
        configureNavigationBar()
//        noteTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        bind(to: viewModel)
        fillInputs()
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        updateProjectChapter()
        checkAndRemove()
    }
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleTextField: BaseTextField = {
        let tf = BaseTextField()
        tf.placeholder = "제목을 입력해주세요."
        tf.setPlaceholder(fontSize: 16, font: .medium)
        tf.font = .pretendardFont(size: 16, style: .medium)
        return tf
    }()
    let contentTextView: BaseTextView = {
        let tv = BaseTextView(viewModel: .init())
        return tv
    }()
    let noteTableView: UITableView = {
        let v = UITableView()
        v.estimatedRowHeight = 178
        v.register(NoteCell.self, forCellReuseIdentifier: NoteCell.self.description())
        v.separatorStyle = .none
        v.isScrollEnabled = false
        return v
    }()
    let addNoteButtonView: ContentsAddButtonView = {
        let v = ContentsAddButtonView(disableMessage: "노트 추가는 3개까지 가능합니다.")
        return v
    }()
    let completeButtonView = CompleteButtonView(viewModel: .init(content: "저장하기", backgroundColor: .disable))
}
extension ProjectChapterInputViewController {
    func setUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        [titleTextField, contentTextView, noteTableView, addNoteButtonView].forEach { contentView.addSubview($0) }
        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(49)
        }
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.height.greaterThanOrEqualTo(200)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        noteTableView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom)
            $0.leading.trailing.equalTo(titleTextField)
            $0.height.equalTo(15)
        }
        
        addNoteButtonView.snp.makeConstraints {
            $0.top.equalTo(noteTableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(80)
        }

 
        view.addSubview(completeButtonView)
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(78)
        }
        
    }
}

extension ProjectChapterInputViewController: UITextViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = noteTableView.cellForRow(at: indexPath)
//        print(cell!.frame)
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        noteTableView.beginUpdates()
        noteTableView.endUpdates()
        updateTableViewHeight()
    }
}

extension ProjectChapterInputViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton() {
        dismiss(animated: true)
        viewModel.noteCellViewModels.remove(at: willDeletedIndex)
        updateTableViewHeight()
    }
    
    func didTapLeftButton() {
        dismiss(animated: true)
    }
    
    
}

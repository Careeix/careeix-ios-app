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
    //    let completeTrigger = PublishRelay<Void>()
    // MARK: Output
    let cellDataDriver: Driver<[NoteCellViewModel]>
    let noteTableViewHeightDriver: Driver<CGFloat>
//    let notes: Driver<[String]>
    init(currentIndex: Int) {
        let combinedInputValuesObservable = Observable.combineLatest(titleStringRelay, contentStringRelay) { ($0, $1) }
        combinedInputValuesObservable.subscribe {
            print($0, $1)
        }
        self.currentIndex = currentIndex
        cellDataDriver = cellDataRelay.asDriver(onErrorJustReturn: [])
       
        noteTableViewHeightDriver = noteTableViewHeightRelay
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
    
    // MARK: Binding
    func bind(to viewModel: ProjectChapterInputViewModel) {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                print("키보드 변경감지", keyboardVisibleHeight == 0 ? "내려가유" : "올라가유")
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
            .debug("😒😒😒노트셀의 데이터😒😒😒")
            .drive(noteTableView.rx.items) { tv, row, data in
                print("😡", data.cellRow, data.inputStringRelay.value)
                guard let cell = tv.dequeueReusableCell(withIdentifier: NoteCell.self.description(), for: IndexPath(row: row, section: 0)) as? NoteCell else { return UITableViewCell() }
                cell.textView.delegate = self
                let text = viewModel.noteCellViewModels[row].inputStringRelay.value
                cell.viewModel = viewModel.noteCellViewModels[row]
                cell.textView.text = text

                return cell
            }.disposed(by: disposeBag)
        
        viewModel.noteTableViewHeightDriver
            .drive(with: self) { owner, height in
                owner.noteTableView.snp.updateConstraints {
                    $0.height.equalTo(height + 10)
                }
            }.disposed(by: disposeBag)
        
//        viewModel.notes
//            .debug("🤯🤯🤯노트들🤯🤯🤯")
//            .drive { a in
//                print(a)
//            }.disposed(by: disposeBag)
    }
    // MARK: Function
    func updateTableViewHeight() {
        let a: CGFloat = noteTableView.visibleCells
            .map { $0.frame.height }
            .reduce(0) { $0 + $1 }
        
        viewModel.noteTableViewHeightRelay
            .accept(a)
            
//        noteTableView.visibleCells
//            .compactMap { $0 as? NoteCell }
//            .enumerated()
//            .forEach { index, cell in
//                print("\(index)번째 노트의 내용: ", cell.viewModel?.inputStringRelay.value)
//            }
    }
    func addNoteCell() {
        print("노트를 추가하는 함수가 호출되었어요")
        view.endEditing(false)
        viewModel.noteCellViewModels.append(.init(inputStringRelay: BehaviorRelay<String>(value: ""), row: viewModel.noteCellViewModels.count))
        
        updateTableViewHeight()
        
        guard let cell = noteTableView.cellForRow(at: IndexPath(row: viewModel.noteCellViewModels.count-1, section: 0)) as? NoteCell else {
            print("실패~")
            return }
//        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom + 50)
//        scrollView.setContentOffset(bottomOffset, animated: true)
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
        bind(to: viewModel)
        setUI()
        title = "\(viewModel.currentIndex)"
        
        completeButtonView.isUserInteractionEnabled = false
        configureNavigationBar()
        noteTableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        fillInputs()
        tabBarController?.tabBar.isHidden = true
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
        return tf
    }()
    let contentTextView: BaseTextView = {
        let tv = BaseTextView()
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
        let v = ContentsAddButtonView()
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
        addNoteButtonView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(80)
        }
        noteTableView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(0)
            $0.leading.trailing.equalTo(titleTextField)
            $0.bottom.equalTo(addNoteButtonView.snp.top)
            $0.height.equalTo(20)
        }
        
        
        view.addSubview(completeButtonView)
        
        completeButtonView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(78)
        }
        
    }
}

extension ProjectChapterInputViewController: UITableViewDelegate, UITextViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func textViewDidChange(_ textView: UITextView) {
        noteTableView.beginUpdates()
        
       
        noteTableView.endUpdates()
        
        updateTableViewHeight()
    }
}

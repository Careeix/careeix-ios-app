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
struct ProjectChapterInputViewModel {
    // MARK: Input
    let titleStringRelay = PublishRelay<String>()
    let contentStringRelay = PublishRelay<String>()
//    let completeTrigger = PublishRelay<Void>()
    
    let currentIndex: Int
    // MARK: Output
    
    init(currentIndex: Int) {
        let combinedInputValuesObservable = Observable.combineLatest(titleStringRelay, contentStringRelay) { ($0, $1) }
        combinedInputValuesObservable.subscribe {
            print($0, $1)
        }
        self.currentIndex = currentIndex
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
                print(keyboardVisibleHeight)
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
                print("노트 추가 탭!")
            }.disposed(by: disposeBag)
        
        completeButtonView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.didTapCompleteButtonView()
            }.disposed(by: disposeBag)
    }
    // MARK: Function
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
        
        if UserDefaultManager.shared.projectChapters.count < viewModel.currentIndex {
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
        titleTextField.becomeFirstResponder()
        title = "\(viewModel.currentIndex)"
        fillInputs()
//        completeButtonView.isUserInteractionEnabled = false
        configureNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateProjectChapter()
        checkAndRemove()
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
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        noteTableView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(0)
            $0.leading.trailing.equalTo(titleTextField).inset(16)
            $0.height.equalTo(0)
        }
        addNoteButtonView.snp.makeConstraints {
            $0.top.equalTo(noteTableView.snp.bottom).offset(15)
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


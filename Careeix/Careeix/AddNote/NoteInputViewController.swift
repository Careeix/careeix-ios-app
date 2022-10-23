//
//  AddNoteViewController.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxKeyboard
struct NoteInputViewmodel {
    // MARK: Input
    let titleStringRelay = PublishRelay<String>()
    let contentStringRelay = PublishRelay<String>()
    
    // MARK: Output
    init() {
        let combinedInputValuesObservable = Observable.combineLatest(titleStringRelay, contentStringRelay) { ($0, $1) }
        combinedInputValuesObservable.subscribe {
            print($0, $1)
        }
    }
}

class NoteInputViewController: UIViewController {
    var disposeBag = DisposeBag()
    init(viewModel: NoteInputViewmodel) {
        super.init(nibName: nil, bundle: nil)
        bind(to: viewModel)
        setUI()
        titleTextField.becomeFirstResponder()
        completeButtonView.isUserInteractionEnabled = false
    }
    
    func bind(to viewModel: NoteInputViewmodel) {
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
                print("컴플릿 탭 !")
            }.disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension NoteInputViewController {
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


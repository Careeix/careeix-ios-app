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


class ProjectChapterInputViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProjectChapterInputViewModel
    var willDeletedIndex: Int!

    // MARK: Binding
    func bind(to viewModel: ProjectChapterInputViewModel) {
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
                print(data, "데이터를 그릴꺼에요")
                cell.textView.delegate = self
                let text = viewModel.noteCellViewModels[row].textViewModel.inputStringRelay.value
                cell.viewModel = viewModel.noteCellViewModels[row]
                cell.textView.text = text
                cell.textView.rx.tapGesture()
                    .when(.recognized)
                    .withUnretained(self)
                    .bind { owner, _ in
                        owner.scrollToFit(with: cell.frame)
                    }.disposed(by: cell.disposeBag)
                
                cell.deleteButtonImageView
                    .rx.tapGesture()
                    .when(.recognized)
                    .do { [weak self] _ in
                        self?.willDeletedIndex = row
                    }.map { [weak self] _ in
                        self?.willDeletedIndex
                    }
                    .distinctUntilChanged()
                    .withUnretained(self)
                    .bind { owner, _ in
                        owner.willDeletedIndex = row
                        owner.showDeleteNoteWarningAlert()
                    }.disposed(by: cell.disposeBag)
                return cell
            }.disposed(by: disposeBag)

        viewModel.updateTableViewHeightTriggerRelay
            .withUnretained(self)
            .map { owner, _ in owner.getTableViewHeight()}
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
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
            .compactMap(noteTableView.cellForRow(at:))
            .map { $0.frame }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, frame in
                owner.scrollToFit(with: frame)
            }.disposed(by: disposeBag)
    }
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        viewModel.updateTableViewHeightTriggerRelay.accept(())
    }
    
    // MARK: Function
    func scrollToFit(with cellFrame: CGRect) {
        scrollView.setContentOffset(CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.35 + view.convert(cellFrame, to: titleTextField).minY - scrollView.contentOffset.y), animated: true)
    }
    
    func showDeleteNoteWarningAlert() {
        let alert = TwoButtonAlertViewController(viewModel: .init(type: .warningDeleteNote))
        alert.delegate = self
        present(alert, animated: true)
    }
    func setAddButtonViewState(with canAddNote: Bool) {
        addNoteButtonView.enableView.isHidden = !canAddNote
        addNoteButtonView.disableView.isHidden = canAddNote
        addNoteButtonView.isUserInteractionEnabled = canAddNote
    }
    func getTableViewHeight() -> CGFloat {
        return noteTableView.visibleCells
            .map { $0.frame.height }
            .reduce(0) { $0 + $1 }
    }
    
    func addNoteCell() {
        view.endEditing(false)
        viewModel.noteCellViewModels.append(.init(inputStringRelay: BehaviorRelay<String>(value: ""), row: viewModel.noteCellViewModels.count, textViewModel: .init()))
        viewModel.updateTableViewHeightTriggerRelay.accept(())
        guard let cell = noteTableView.cellForRow(at: IndexPath(row: viewModel.noteCellViewModels.count - 1, section: 0)) as? NoteCell else {
            return }
        cell.textView.becomeFirstResponder()
        scrollToFit(with: cell.frame)
    }
    
    func didTapCompleteButtonView() {
        view.endEditing(true)
    }


    // MARK: Initializer
    init(viewModel: ProjectChapterInputViewModel) {
        self.viewModel = viewModel
        titleTextField = BaseTextField(viewModel: viewModel.titleTextFieldViewModel)
        titleTextField.setPlaceholder(fontSize: 16, font: .medium)
        titleTextField.font = .pretendardFont(size: 16, style: .medium)
        contentTextView = BaseTextView(viewModel: viewModel.contentViewModel)
        viewModel.updateProjectChapter()
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setUI()
        title = "\(viewModel.currentIndex)"
        completeButtonView.isUserInteractionEnabled = false
        configureNavigationBar()
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
        noteTableView.beginUpdates()
        viewModel.fillInputs()
        view.layoutIfNeeded()
        noteTableView.endUpdates()
    }
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        viewModel.checkAndRemove()
    }
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
       
    }
    
    // MARK: UIComponents
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleTextField: BaseTextField
    let contentTextView: BaseTextView
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
    func textViewDidChange(_ textView: UITextView) {
        noteTableView.beginUpdates()
        noteTableView.endUpdates()
        viewModel.updateTableViewHeightTriggerRelay.accept(())
    }
}

extension ProjectChapterInputViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        viewModel.noteCellViewModels.remove(at: willDeletedIndex)
        viewModel.updateTableViewHeightTriggerRelay.accept(())
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
    }
}

extension UITableView {
    open override func layoutSubviews() {
        print("테이블뷰 콘텐츠 싸이즈 !", contentSize.height)
    }
}

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

    // MARK: - Binding
    func bind(to viewModel: ProjectChapterInputViewModel) {
        RxKeyboard.instance.visibleHeight
            .skip(1)    // 초기 값 버리기
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.updateView(with: keyboardVisibleHeight)
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
                cell.textView.delegate = self
                
                cell.bind(to: data)
                
                cell.textView.rx.tapGesture()
                    .when(.recognized)
                    .withUnretained(self)
                    .bind { owner, _ in
                        owner.scrollToFit(with: cell.frame)
                    }.disposed(by: cell.disposeBag)
                
                cell.deleteButtonImageView
                    .rx.tapGesture()
                    .when(.recognized)
                    .withUnretained(self)
                    .do { owner, _ in
                        owner.willDeletedIndex = row
                    }.map { owner, _ in
                        owner.willDeletedIndex
                    }
                    .distinctUntilChanged()
                    .asDriver(onErrorJustReturn: 0)
                    .drive(with: self) { owner, _ in
                        owner.showDeleteNoteWarningAlert()
                    }.disposed(by: cell.disposeBag)
                return cell
            }.disposed(by: disposeBag)

        viewModel.updateProjectChapterDriver
            .drive { data in
                viewModel.updateProjectChapter(data: data)
            }.disposed(by: disposeBag)
        
        viewModel.completeButtonEnableDriver
            .drive(with: self) { owner,  isEnable in
                owner.updateCompleteButtonView(with: isEnable)
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
            .drive(with: self) { owner, canAddChapter in
                owner.setAddButtonViewState(with: canAddChapter)
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
    
    // MARK: - Function
    func updateCompleteButtonView(with isEnable: Bool) {
        completeButtonView.backgroundColor = isEnable ? .appColor(.next) : .appColor(.disable)
        completeButtonView.isUserInteractionEnabled = isEnable
    }
    
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
            .map { cell in cell.frame.height }.reduce(0) { $0 + $1 }
    }
    
    override func viewDidLayoutSubviews() {
        viewModel.noteTableViewHeightRelay.accept(noteTableView.contentSize.height)
    }
    
    func addNoteCell() {
        view.endEditing(false)
        viewModel.noteCellViewModels.append(.init(inputStringRelay: BehaviorRelay<String>(value: "")))
        viewModel.noteTableViewHeightRelay.accept(noteTableView.contentSize.height)
        guard let cell = noteTableView.cellForRow(at: IndexPath(row: viewModel.noteCellViewModels.count - 1, section: 0)) as? NoteCell else {
            return }
        cell.textView.becomeFirstResponder()
        scrollToFit(with: cell.frame)
    }
    
    func didTapCompleteButtonView() {
        view.endEditing(true)
        let vc = OneButtonAlertViewController(viewModel: .init(content: "저장되었습니다!", buttonText: "확인", textColor: .point))
        present(vc, animated: true)
    }
    
    func updateView(with keyboardHeight: CGFloat) {
        contentView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        completeButtonView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Initializer
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
        completeButtonView.isUserInteractionEnabled = false
        setupNavigationBackButton()
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        viewModel.fillInputs()
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        bind(to: viewModel)
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.checkAndRemove()
    }
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - UIComponents
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
            $0.height.equalTo(10)
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
        viewModel.noteTableViewHeightRelay.accept(getTableViewHeight())
    }
}

extension ProjectChapterInputViewController: TwoButtonAlertViewDelegate {
    func didTapRightButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
        viewModel.noteCellViewModels.remove(at: willDeletedIndex)
        viewModel.noteTableViewHeightRelay.accept(getTableViewHeight())
    }
    
    func didTapLeftButton(type: TwoButtonAlertType) {
        dismiss(animated: true)
    }
}

//
//  DatePickerView.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/22.
//

import UIKit
import SnapKit

struct DatePickerViewModel {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

/// 3가지 프로퍼티로 intrinsic Height 정할 수 있습니다.
/// datePickerHeight
/// datePickerTopViewHeight
/// datePickerShadowHeight
class DatePickerView: UIView {
    static let datePickerHeight: CGFloat = 250
    static let datePickerTopViewHeight: CGFloat = 41
    static let datePickerShadowHeight: CGFloat = 4
    
    init(viewModel: DatePickerViewModel) {
        
        super.init(frame: .zero)
        configure()
        bind(to: viewModel)
        setUI()
        
    }
    
    func configure() {
        backgroundColor = .white
        layer.shadowColor = UIColor.appColor(.gray200).cgColor
        layer.masksToBounds = false
        layer.shadowOffset = .init(width: 0, height: DatePickerView.datePickerShadowHeight)
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
        layer.cornerRadius = 20
    }
    
    func bind(to viewModel: DatePickerViewModel) {
        datePickerTopViewLeftLabel.text = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIComponents
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        return dp
    }()
    let datePickerTopView: UIView = {
        let v = UIView()
        return v
    }()
    let datePickerTopViewLeftLabel: UILabel = {
        let l = UILabel()
        l.font = .pretendardFont(size: 16, style: .medium)
        l.textColor = .appColor(.gray250)
        return l
    }()
    let datePickerTopViewRightLabel: UILabel = {
        let l = UILabel()
        l.text = "완료"
        l.font = .pretendardFont(size: 15, style: .regular)
        l.textColor = .appColor(.point)
        return l
    }()
    
    func setUI() {
        addSubview(datePicker)
        addSubview(datePickerTopView)
        datePicker.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(DatePickerView.datePickerHeight)
        }
        
        datePickerTopView.snp.makeConstraints {
            $0.bottom.equalTo(datePicker.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(DatePickerView.datePickerTopViewHeight)
            $0.top.equalToSuperview()
        }
        
        [datePickerTopViewLeftLabel, datePickerTopViewRightLabel].forEach { datePickerTopView.addSubview($0) }
        
        datePickerTopViewLeftLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(13)
        }
        datePickerTopViewRightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

//
//  HomeAlertViewController.swift
//  Careeix
//
//  Created by mingmac on 2022/10/17.
//

import Foundation
import UIKit
import SnapKit

class HomeAlertViewController: UIViewController {
    static let identifier = "HomeAlertViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        buttonAction()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        tabBarController?.tabBar.isHidden = false
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        let name = CareerModel.minimalCareerProfile.map { $0.nickname }
        label.text = "\(name[0])님, 반가워요!"
        label.font = .pretendardFont(size: 18, style: .medium)
        label.textColor = .appColor(.gray900)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "careeix에 오신 걸 환영해요! \n당신의 빛나는 성장을 기록해보세요."
        label.numberOfLines = 0
        label.addInterlineSpacing(spacingValue: 5)
        label.font = .pretendardFont(size: 15, style: .regular)
        label.textColor = .appColor(.gray600)
        return label
    }()
    
    let modalImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "greet")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.appColor(.gray400), for: .normal)
        button.titleLabel?.font = .pretendardFont(size: 15, style: .light)
        button.backgroundColor = .clear
        button.contentMode = .center
        return button
    }()
    
    func buttonAction() {
        confirmButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    func setup() {
        view.addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(425)
        }
        
        [titleLabel, descriptionLabel, modalImageView, confirmButton]
            .forEach { containerView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(29)
            $0.leading.equalToSuperview().offset(26)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(37)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.11)
        }
        
        modalImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(25.16)
            $0.width.equalTo(266)
            $0.height.equalTo(225)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(modalImageView.snp.bottom).offset(17)
            $0.bottom.equalToSuperview().inset(26)
        }
    }
}

private extension UILabel {
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))
        attributedText = attributedString
    }
}

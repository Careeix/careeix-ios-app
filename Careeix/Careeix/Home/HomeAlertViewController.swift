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
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleText: UILabel = {
        let label = UILabel()
        label.text = "가입을 축하해요!"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let descriptionText: UILabel = {
        let label = UILabel()
        label.text = "회원가입을 축하해요! \ncareeix에서 당신의 성장을 기록해보세요."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    let modalImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "questionmark.circle")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
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
        
        [titleText, descriptionText, modalImage, confirmButton]
            .forEach { containerView.addSubview($0) }
        
        titleText.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        descriptionText.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleText.snp.bottom)
        }
        
        modalImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(descriptionText.snp.bottom)
            $0.width.equalTo(343)
            $0.height.equalTo(425)
        }
        
        confirmButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

//
//  MinimalCareerProfile.swift
//  Careeix
//
//  Created by mingmac on 2022/10/14.
//

import Foundation
import SnapKit
import UIKit
import Kingfisher

/**
 2. 간편 커리어 프로필
    - Compositional Layout
        - cell 하나
    - Diffable Datasource
        - 뷰 안에 프로필 이미지, 닉네임, 직무, 연차, 상세 직무 태그
    - Snapshot
*/

class MinimalCareerProfileCell: UICollectionViewCell {
    var userId: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gradientView = UIView()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 75 / 2
        image.clipsToBounds = true
        return image
    }()
    
    let nickName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 20, style: .bold)
        return label
    }()
    
    let careerName: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 18, style: .bold)
        return label
    }()
    
    let careerGrade: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.white)
        label.font = .pretendardFont(size: 14, style: .light)
        return label
    }()

    func configure(_ info: UserModel) {
        setImageURL(url: info.userProfileImg ?? "")
        nickName.text = info.userNickname
        careerName.text = info.userJob
        careerGrade.text = UserWork.setUserWork(grade: info.userWork)
        userId = info.userId
        setProfileColor(fillColor: info.userProfileColor)
    }
    
    func setImageURL(url: String) {
        let url = URL(string: url)
        if url == nil {
            profileImageView.image = UIImage(named: "basicProfile")
        } else {
            profileImageView.kf.setImage(with: url)
        }
    }
    
    func setProfileColor(fillColor: String) {
        GradientColor(rawValue: fillColor)?.setGradient(contentView: gradientView, cornerRadius: 10)
    }
    
    override func prepareForReuse() {
        userId = -1
    }
    
    func setup() {
        contentView.addSubview(gradientView)
        
        gradientView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [profileImageView, nickName, careerName, careerGrade]
            .forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(24)
            $0.width.height.equalTo(75)
            $0.top.equalToSuperview()
        }
        
        nickName.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(5)
            $0.top.equalTo(gradientView.snp.top).offset(10)
        }
        
        careerName.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalTo(profileImageView.snp.bottom).offset(11)
        }
        
        careerGrade.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(27)
            $0.top.equalTo(careerName.snp.bottom).offset(6)
        }
    }
}

// MARK: convert Hex to UIColor

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

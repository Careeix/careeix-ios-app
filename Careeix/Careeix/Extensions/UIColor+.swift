//
//  UIColor+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit

enum AssetsColor {
    case main, point
    case gray10, gray20, gray30, gray100, gray150, gray200, gray250, gray300, gray400, gray500, gray600, gray700, gray900, white, black
    case next, progressBar, disable, date, text, name, line, deep
    case error, iphone_bule
}
extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .main:
            return UIColor(red: 187/255.0, green: 163/255.0, blue: 255/255.0, alpha: 1)
        case .point:
            return UIColor(red: 66/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        case .gray10:
            return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        case .gray20:
            return UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)
        case .gray30:
            return UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1)
        case .gray100:
            return UIColor(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1)
        case .gray150:
            return UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
        case .gray200:
            return UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        case .gray250:
            return UIColor(red: 182/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)
        case .gray300:
            return UIColor(red: 165/255.0, green: 165/255.0, blue: 165/255.0, alpha: 1)
        case .gray400:
            return UIColor(red: 156/255.0, green: 156/255.0, blue: 156/255.0, alpha: 1)
        case .gray500:
            return UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        case .gray600:
            return UIColor(red: 107/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1)
        case .gray700:
            return UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        case .gray900:
            return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        case .white:
            return UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        case .black:
            return UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)
        case .next:
            return UIColor(red: 214/255.0, green: 200/255.0, blue: 255/255.0, alpha: 1)
        case .progressBar:
            return UIColor(red: 183/255.0, green: 178/255.0, blue: 236/255.0, alpha: 1)
        case .disable:
            return UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
        case .date:
            return UIColor(red: 95/255.0, green: 93/255.0, blue: 204/255.0, alpha: 1)
        case .text:
            return UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1)
        case .name:
            return UIColor(red: 74/255.0, green: 73/255.0, blue: 124/255.0, alpha: 1)
        case .line:
            return UIColor(red: 236/255.0, green: 235/255.0, blue: 241/255.0, alpha: 1)
        case .deep:
            return UIColor(red: 67/255.0, green: 66/255.0, blue: 84/255.0, alpha: 1)
        case .error:
            return UIColor(red: 248/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1)
        case .iphone_bule:
            return UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1)
        }
        
    }
}

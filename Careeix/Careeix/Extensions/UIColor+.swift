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
    case skyblueFill, pinkFill, yellowFill, purpleFill, orangeFill, greenFill
    case skyblueGradientSP, pinkGradientSP, yellowGradientSP, purpleGradientSP, orangeGradientSP, greenGradientSP
    case skyblueGradientEP, pinkGradientEP, yellowGradientEP, purpleGradientEP, orangeGradientEP, greenGradientEP
    case notePurple, noteGreen, noteYellow
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
            return UIColor(red: 95/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1)
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
        case .skyblueFill:
            return UIColor(red: 141/255, green: 184/255, blue: 223/255, alpha: 1)
        case .pinkFill:
            return UIColor(red: 220/255, green: 99/255, blue: 157/255, alpha: 1)
        case .yellowFill:
            return UIColor(red: 182/255, green: 154/255, blue: 13/255, alpha: 1)
        case .purpleFill:
            return UIColor(red: 165/255, green: 173/255, blue: 245/255, alpha: 1)
        case .orangeFill:
            return UIColor(red: 240/255, green: 183/255, blue: 130/255, alpha: 1)
        case .greenFill:
            return UIColor(red: 105/255, green: 157/255, blue: 132/255, alpha: 1)
        case .skyblueGradientSP:
            return UIColor(red: 53/255, green: 120/255, blue: 181/255, alpha: 0.9)
        case .pinkGradientSP:
            return UIColor(red: 233/255, green: 166/255, blue: 198/255, alpha: 0.9)
        case .yellowGradientSP:
            return UIColor(red: 232/255, green: 205/255, blue: 68/255, alpha: 0.9)
        case .purpleGradientSP:
            return UIColor(red: 46/255, green: 59/255, blue: 171/255, alpha: 0.9)
        case .orangeGradientSP:
            return UIColor(red: 252/255, green: 143/255, blue: 42/255, alpha: 0.9)
        case .greenGradientSP:
            return UIColor(red: 34/255, green: 91/255, blue: 64/255, alpha: 0.9)
        case .skyblueGradientEP:
            return UIColor(red: 105/255, green: 175/255, blue: 239/255, alpha: 0.45)
        case .pinkGradientEP:
            return UIColor(red: 229/255, green: 135/255, blue: 180/255, alpha: 0.45)
        case .yellowGradientEP:
            return UIColor(red: 234/255, green: 205/255, blue: 61/255, alpha: 0.45)
        case .purpleGradientEP:
            return UIColor(red: 107/255, green: 106/255, blue: 195/255, alpha: 0.45)
        case .orangeGradientEP:
            return UIColor(red: 246/255, green: 155/255, blue: 70/255, alpha: 0.45)
        case .greenGradientEP:
            return UIColor(red: 100/255, green: 146/255, blue: 124/255, alpha: 0.45)
        case .notePurple:
            return UIColor(red: 234/255, green: 232/255, blue: 245/255, alpha: 1)
        case .noteGreen:
            return UIColor(red: 232/255, green: 245/255, blue: 232/255, alpha: 1)
        case .noteYellow:
            return UIColor(red: 252/255, green: 245/255, blue: 221/255, alpha: 1)
        }
        
    }
}

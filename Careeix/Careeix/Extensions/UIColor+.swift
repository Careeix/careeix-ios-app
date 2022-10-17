//
//  UIColor+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/15.
//

import UIKit

enum AssetsColor {
    case error
    case signature
    case signatureLight
    case signatureDark

}
extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        switch name {
        case .error:
            return UIColor(red: 248/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1)
        case .signature:
            return UIColor(red: 214/255.0, green: 200/255.0, blue: 255/255.0, alpha: 1)
        case .signatureLight:
            return UIColor(red: 234/255.0, green: 232/255.0, blue: 245/255.0, alpha: 1)
        case .signatureDark:
            return UIColor(red: 187/255.0, green: 163/255.0, blue: 255/255.0, alpha: 1)
        }
        
    }
}

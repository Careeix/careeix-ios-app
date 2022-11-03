//
//  Int+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/03.
//

import Foundation

extension Int {
    func zeroFillTenDigits() -> String {
        String(format: "%02d", self)
    }
}

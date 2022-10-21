//
//  Date+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/20.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "YYYY-MM-dd"
        return dateFomatter.string(from: self)
    }
}

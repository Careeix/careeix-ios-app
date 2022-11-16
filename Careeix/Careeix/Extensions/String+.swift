//
//  String+.swift
//  Careeix
//
//  Created by 김지훈 on 2022/11/17.
//

import Foundation
extension String {
    func toDate() -> Date {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "YYYY-MM-dd"
        return dateFomatter.date(from: self) ?? Date()
    }
}

//
//  ProjectChapter.swift
//  Careeix
//
//  Created by 김지훈 on 2022/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
struct ProjectChapter: Codable {
    var title: String
    var content: String
    var notes: [String]
}

struct ProjectBaseInputValue: Codable {
    var title: String
    var startDateString: String = Date().toString()
    var endDateString: String = Date().toString()
    var division: String
    var indroduce: String
    var isProceed: Bool = false
    
    func checkRemain() -> Bool {
        print(startDateString, endDateString, "asdadaaa")
        return title != ""
        || startDateString != Date().toString()
        || endDateString != Date().toString()
        || division != ""
        || indroduce != ""
        || isProceed
    }
    
}

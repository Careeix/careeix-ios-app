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

struct Project: Codable, Equatable {
    var title: String
    var startDateString: String
    var endDateString: String?
    var classification: String
    var introduce: String
    var isProceed: Int
    var projectChapters: [ProjectChapter]
    
    enum CodingKeys: String, CodingKey {
        case title
        case startDateString = "start_date"
        case endDateString = "end_date"
        case classification = "classification"
        case introduce = "introduction"
        case isProceed = "is_proceed"
        case projectChapters = "projectDetails"
    }
    
    init(title: String = "",
         startDateString: String = "",
         endDateString: String? = "",
         classification: String = "",
         introduce: String = "",
         isProceed: Int = 0,
         projectChapters: [ProjectChapter] = []
    ) {
        self.title = title
        self.startDateString = startDateString
        self.endDateString = endDateString
        self.classification = classification
        self.introduce = introduce
        self.isProceed = isProceed
        self.projectChapters = projectChapters
    }
}

struct ProjectBaseInfo: Codable, Equatable {
    var title: String
    var startDateString: String = Date().toString()
    var endDateString: String? = Date().toString()
    var classification: String
    var introduce: String
    var isProceed: Bool = false
}

struct ProjectChapter: Codable, Equatable {
    var title: String
    var content: String
    var notes: [Note]
    enum CodingKeys: String, CodingKey {
        case title = "project_detail_title"
        case content
        case notes = "projectNotes"
    }
}

struct Note: Codable, Equatable {
    let content: String
}

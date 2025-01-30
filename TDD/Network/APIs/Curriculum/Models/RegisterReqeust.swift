//
//  RegisterReqeust.swift
//  TDD
//
//  Created by 최안용 on 12/22/24.
//

import Foundation

struct RegisterReqeust: Encodable {
    var registerRequest: [DetailCurriculum]
    let curriculumRequest: DetailCurriculumRequest
}

struct DetailCurriculum: Encodable {
    var weekTitle: String
    let objective: String
    let contentRequests: [ContentRequest]
}

struct ContentRequest: Encodable {
    let content: String
    let isChecked: Bool
}

struct DetailCurriculumRequest: Encodable {
    let position: String
    let stack: String
    let experienceLevel: String
    let targetPeriod: Int
}

//
//  Curriculum.swift
//  TDD
//
//  Created by 최안용 on 11/13/24.
//

import Foundation

struct Curriculum: Hashable {
    var isRegistration = false
    let object: String
    var contents: [DetailSubject]
}

struct DetailSubject: Identifiable, Hashable {
    var isSelected: Bool = false
    let id =  UUID()
    let title: String
}

extension Curriculum {
    func toDTO() -> DetailCurriculum {
        return .init(
            weekTitle: "",
            objective: object,
            contentRequests: contents.map { .init(content: $0.title, isChecked: $0.isSelected)}
        )
    }
}

//
//  FetchCurriculumResponse.swift
//  TDD
//
//  Created by 최안용 on 1/30/25.
//

import Foundation

struct FetchCurriculumResponse: Decodable {
    let contentRequests: [DetailFetchCurriculumResponse]
    let objective: String
    let weekTitle: String
}

struct DetailFetchCurriculumResponse: Decodable {
    let content: String
    let isChecked: Bool
}

extension FetchCurriculumResponse {
    func toModel() -> Curriculum {
        return .init(
            isRegistration: true,
            object: objective,
            contents: contentRequests.map {
                DetailSubject(isSelected: $0.isChecked, title: $0.content)
            }
        )
    }
}

//
//  CurriculumResponse.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import Foundation

struct CurriculumResponse: Decodable {
    let curriculum: [DetailResponse]
}

struct DetailResponse: Decodable {
    let weekTitle: String
    let objective: String
    let learningContents: [ContentsResponse]
}

struct ContentsResponse: Decodable {
    let content: String
}

extension CurriculumResponse {
    func toModel() -> [Curriculum] {
        return curriculum.map { detail in
            Curriculum(
                object: detail.objective,
                contents: detail.learningContents.map { content in
                    DetailSubject(title: content.content)
                }
            )
        }
    }
}

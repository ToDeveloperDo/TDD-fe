//
//  MakeCurriculumRequest.swift
//  TDD
//
//  Created by 최안용 on 11/10/24.
//

import Foundation

struct MakeCurriculumRequest: Encodable {
    let position: String
    let stack: String
    let experienceLevel: String
    let targetPeriod: Int
}

//
//  Plan.swift
//  TDD
//
//  Created by 최안용 on 12/23/24.
//

import Foundation

struct Plan: Hashable {
    let position: String
    let stack: String
    let experienceLevel: String
    let targetPeriod: Int
    let createDt: String
    let planId: Int
}

extension Plan {
    static func makePlan() -> [Plan] {
        return [
            .init(
                position: "프론트엔드",
                stack: "react,node.js",
                experienceLevel: "하",
                targetPeriod: 3,
                createDt: "2024-12-13T15:38:24.543984",
                planId: 1
            ),
            .init(
                position: "백엔드",
                stack: "Spring boot",
                experienceLevel: "중",
                targetPeriod: 2,
                createDt: "2024-12-16T15:38:24.543984",
                planId: 2
            )
        ]
    }
}

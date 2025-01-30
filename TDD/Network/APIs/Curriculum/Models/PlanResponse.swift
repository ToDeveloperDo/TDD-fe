//
//  PlanResponse.swift
//  TDD
//
//  Created by 최안용 on 12/23/24.
//

import Foundation

struct PlanResponse: Decodable {
    let position: String
    let stack: String
    let experienceLevel: String
    let targetPeriod: Int
    let createDt: String
    let planId: Int
}

extension PlanResponse {
    func toModel() -> Plan {
        Plan(
            position: position,
            stack: stack,
            experienceLevel: experienceLevel,
            targetPeriod: targetPeriod,
            createDt: createDt,
            planId: planId
        )
    }
}

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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        let date = formatter.date(from: createDt) ?? Date()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        let dateString = formatter.string(from: date)
        
        return Plan(
            position: position,
            stack: stack,
            experienceLevel: experienceLevel,
            targetPeriod: targetPeriod,
            createDt: dateString,
            planId: planId
        )
    }
}

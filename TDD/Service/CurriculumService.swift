//
//  CurriculumService.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import Foundation
import Combine

protocol CurriculumServiceType {
    func fetchCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError>
}

final class CurriculumService: CurriculumServiceType {
    func fetchCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError> {
        let periodSliced = period.split(separator: "")
        let numPeriod = Int(periodSliced.first ?? "0") ?? 0
        let request = MakeCurriculumRequest(
            position: position,
            stack: stack,
            experienceLevel: experience,
            targetPeriod: numPeriod
        )
        
        return NetworkingManager.shared.requestWithAuth(
            CurriculumTarget.makeCurriculum(request: request),
            type: CurriculumResponse.self
        )
        .map { $0.toModel() }
        .mapError { error in
            switch error {
            case .notRepository:
                return ServiceError.notRepository
            case .serverError(let message):
                return ServiceError.serverError(message)
            case .error(let error):
                return ServiceError.error(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

final class StubCurriculumService: CurriculumServiceType {
    func fetchCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
}

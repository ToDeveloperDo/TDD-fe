//
//  CurriculumService.swift
//  TDD
//
//  Created by 최안용 on 11/12/24.
//

import Foundation
import Combine

protocol CurriculumServiceType {
    func makeCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError>
    func saveCurriculum(request: RegisterReqeust) -> AnyPublisher<Void, ServiceError>
    func fetchPlan() -> AnyPublisher<[Plan], ServiceError>
    func fetchCurriculum(id: Int) -> AnyPublisher<[Curriculum], ServiceError>
}

final class CurriculumService: CurriculumServiceType {
    func makeCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError> {
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
    
    func saveCurriculum(request: RegisterReqeust) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(
            CurriculumTarget.saveCurriculum(request: request),
            type: EmptyResponse.self
        )
        .map { _ in () }
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
    
    func fetchPlan() -> AnyPublisher<[Plan], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(
            CurriculumTarget.fetchPlan,
            type: [PlanResponse].self
        )
        .map { $0.map { $0.toModel() } }
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
    
    func fetchCurriculum(id: Int) -> AnyPublisher<[Curriculum], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(
            CurriculumTarget.fetchCurriculum(id: id),
            type: [FetchCurriculumResponse].self
        )
        .map { $0.map { $0.toModel() } }
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
    func fetchPlan() -> AnyPublisher<[Plan], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func makeCurriculum(position: String, stack: String, experience: String, period: String) -> AnyPublisher<[Curriculum], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func saveCurriculum(request: RegisterReqeust) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchCurriculum(id: Int) -> AnyPublisher<[Curriculum], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}

//
//  GitHubService.swift
//  TDD
//
//  Created by 최안용 on 8/2/24.
//

import Foundation
import Combine

protocol GitHubSericeType {
    func isGitLink() -> AnyPublisher<Void, ServiceError>
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Void, ServiceError>
}

final class GitHubService: GitHubSericeType{
    func isGitLink() -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(GitHubAPITarget.isGitLink, type: EmptyResponse.self)
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
    
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(GitHubAPITarget.createRepo(request), type: EmptyResponse.self)
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
}

final class StubGitHubService: GitHubSericeType {
    func isGitLink() -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}

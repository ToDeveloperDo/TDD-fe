//
//  GitHubService.swift
//  TDD
//
//  Created by 최안용 on 8/2/24.
//

import Foundation
import Combine

protocol GitHubSericeType {
    func isGitLink() -> AnyPublisher<Bool, ServiceError>
    func isRepoCreated() -> AnyPublisher<Bool, ServiceError>
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Bool, ServiceError>
}

final class GitHubService: GitHubSericeType{
    private var githubAPI: GitHubAPI
    
    init(githubAPI: GitHubAPI) {
        self.githubAPI = githubAPI
    }
    
    func isGitLink() -> AnyPublisher<Bool, ServiceError> {
        return githubAPI.isGitLink()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func isRepoCreated() -> AnyPublisher<Bool, ServiceError> {
        return githubAPI.isRepoCreated()
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Bool, ServiceError> {
        return githubAPI.createRepo(request: request)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubGitHubService: GitHubSericeType {
    func isGitLink() -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func isRepoCreated() -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    
}

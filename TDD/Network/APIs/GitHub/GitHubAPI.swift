//
//  RepoAPI.swift
//  TDD
//
//  Created by 최안용 on 7/22/24.
//

import Foundation
import Combine
import Alamofire

final class GitHubAPI {
    func isGitLink() -> AnyPublisher<Bool, Error> {
        return API.session.request(GitHubAPITarget.isGitLink, interceptor: AuthInterceptor.shared)
            .publishData()
            .tryMap { response -> Bool in
                guard let httpResponse = response.response,
                      httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func isRepoCreated() -> AnyPublisher<Bool, Error> {
        return API.session.request(GitHubAPITarget.isRepoCreated, interceptor: AuthInterceptor.shared)
            .publishData()
            .tryMap { response -> Bool in
                guard let httpResponse = response.response,
                      httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func createRepo(request: CreateRepoRequest) -> AnyPublisher<Bool, Error> {
        return API.session.request(GitHubAPITarget.createRepo(request), interceptor: AuthInterceptor.shared)
            .publishData()
            .tryMap { response -> Bool in
                guard let httpResponse = response.response,
                      httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .mapError { $0 }
            .eraseToAnyPublisher()

    }
}

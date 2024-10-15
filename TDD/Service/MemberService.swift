//
//  MemberService.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Combine

protocol MemberServiceType {
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError>
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError>
    func updateFcmToken(token: String) -> AnyPublisher<Void, ServiceError>
}

final class MemberService: MemberServiceType {
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(MemberTarget.fetchMyInfo, type: FetchMyInfoResponse.self)
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
    
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(MemberTarget.fetchAllMember, type: [FriendResponse].self)
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
    
    func updateFcmToken(token: String) -> AnyPublisher<Void, ServiceError> {
        let request = FCMTokenRequest(fcmToken: token)
        return NetworkingManager.shared.requestWithAuth(MemberTarget.updateFcmToken(token: request), type: EmptyResponse.self)
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

final class StubMemberService: MemberServiceType {
    func updateFcmToken(token: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError> {
        Just(.stub)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([.stu1, .stu2, .stu3, .stu4])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}

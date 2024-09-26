//
//  FriendService.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Combine

protocol FriendServiceType {
    func searchFriend(userName: String) -> AnyPublisher<UserInfo, ServiceError>
    func fetchFriendList() -> AnyPublisher<[UserInfo], ServiceError>
    func fetchFriend(id: Int64) -> AnyPublisher<UserInfo, ServiceError>
    func fetchSendList() -> AnyPublisher<[UserInfo], ServiceError>
    func fetchReceiveList() -> AnyPublisher<[UserInfo], ServiceError>
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[FriendTodoList], ServiceError>
    func addFriend(id: Int64) -> AnyPublisher<Void, ServiceError>
    func acceptFriend(id: Int64) -> AnyPublisher<Void, ServiceError>
    func deleteFriend(id: Int64, type: InfoType) -> AnyPublisher<Void, ServiceError>
}

final class FriendService: FriendServiceType {
    func searchFriend(userName: String) -> AnyPublisher<UserInfo, ServiceError> {
        let request = SearchReqeust(gitUserName: userName)
        return NetworkingManager.shared.requestWithAuth(FriendTarget.searchFriend(request),
                                                        type: FriendResponse.self)
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
    
    func fetchFriendList() -> AnyPublisher<[UserInfo], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.fetchFriendList, type: [FriendNotStateResponse].self)
            .map { $0.map { $0.toFriendModel() } }
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
    
    func fetchFriend(id: Int64) -> AnyPublisher<UserInfo, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.fetchFriend(id), type: FriendNotStateResponse.self)
            .map { $0.toFriendModel() }
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
    
    func fetchSendList() -> AnyPublisher<[UserInfo], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.fetchSendList, type: [FriendNotStateResponse].self)
            .map { $0.map { $0.toSendModel() } }
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
    
    func fetchReceiveList() -> AnyPublisher<[UserInfo], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.fetchReceive, type: [FriendNotStateResponse].self)
            .map { $0.map { $0.toRecivetModel() } }
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
    
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[FriendTodoList], ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.fetchFriendTodoList(id), type: [FetchFriendTodoListResponse].self)
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
    
    func addFriend(id: Int64) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.addFriend(id), type: EmptyResponse.self)
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
    
    func acceptFriend(id: Int64) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(FriendTarget.acceptFriend(id), type: EmptyResponse.self)
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
    
    func deleteFriend(id: Int64, type: InfoType) -> AnyPublisher<Void, ServiceError> {
        let request = DeleteRequest(type: type.deleteString)
        
        return NetworkingManager.shared.requestWithAuth(FriendTarget.deleteFriend(id, request), type: EmptyResponse.self)
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

final class StubFriendService: FriendServiceType {
    func searchFriend(userName: String) -> AnyPublisher<UserInfo, ServiceError> {
        Just(.stu1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchFriendList() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([.stu1, .stu2, .stu3, .stu4]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchFriend(id: Int64) -> AnyPublisher<UserInfo, ServiceError> {
        Just(.stu1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchSendList() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchReceiveList() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([.stu1, .stu2, .stu3, .stu4]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[FriendTodoList], ServiceError> {
        Just([.init(deadline: "2024-04-08", todos: [.stub1,.stub2])]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func addFriend(id: Int64) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func acceptFriend(id: Int64) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func deleteFriend(id: Int64, type: InfoType) -> AnyPublisher<Void, ServiceError>  {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    
}

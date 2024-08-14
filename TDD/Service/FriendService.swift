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
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[Todo], ServiceError>
    func addFriend(id: Int64) -> AnyPublisher<Bool, ServiceError>
    func acceptFriend(id: Int64) -> AnyPublisher<Bool, ServiceError>
    func deleteFriend(id: Int64) -> AnyPublisher<Bool, ServiceError>
}

final class FriendService: FriendServiceType {
    private var friendAPI: FriendAPI
    
    init(friendAPI: FriendAPI) {
        self.friendAPI = friendAPI
    }
    
    func searchFriend(userName: String) -> AnyPublisher<UserInfo, ServiceError> {
        let request = SearchReqeust(gitUserName: userName)
        return friendAPI.searchFriend(request: request)
            .map { $0.toModel() }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchFriendList() -> AnyPublisher<[UserInfo], ServiceError> {
        return friendAPI.fetchFriendList()
            .map { $0.map { $0.toFriendModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchFriend(id: Int64) -> AnyPublisher<UserInfo, ServiceError> {
        return friendAPI.fetchFriend(id: id)
            .map { $0.toFriendModel() }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchSendList() -> AnyPublisher<[UserInfo], ServiceError> {
        return friendAPI.fetchSendList()
            .map { $0.map { $0.toSendModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchReceiveList() -> AnyPublisher<[UserInfo], ServiceError> {
        return friendAPI.fetchReceive()
            .map { $0.map { $0.toRecivetModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[Todo], ServiceError> {
        return friendAPI.fetchFriendTodoList(id: id)
            .map { $0.map { $0.toModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func addFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        return friendAPI.addFriend(id: id)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func acceptFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        return friendAPI.acceptFriend(id: id)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        return friendAPI.deleteFriend(id: id)
            .mapError { ServiceError.error($0) }
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
        Just([.stu1, .stu2, .stu3, .stu4]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchReceiveList() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([.stu1, .stu2, .stu3, .stu4]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[Todo], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func addFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func acceptFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func deleteFriend(id: Int64) -> AnyPublisher<Bool, ServiceError> {
        Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    
}

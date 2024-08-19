//
//  FriendAPI.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation
import Combine
import Alamofire

final class FriendAPI {
    func searchFriend(request: SearchReqeust) -> AnyPublisher<FriendResponse, Error> {
        return API.session.request(FriendTarget.searchFriend(request), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: FriendResponse.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchFriendList() -> AnyPublisher<[FriendNotStateResponse], Error> {
        return API.session.request(FriendTarget.fetchFriendList, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [FriendNotStateResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchFriend(id: Int64) -> AnyPublisher<FriendNotStateResponse, Error> {
        return API.session.request(FriendTarget.fetchFriend(id), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: FriendNotStateResponse.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchSendList() -> AnyPublisher<[FriendNotStateResponse], Error> {
        return API.session.request(FriendTarget.fetchSendList, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [FriendNotStateResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchReceive() -> AnyPublisher<[FriendNotStateResponse], Error> {
        return API.session.request(FriendTarget.fetchReceive, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [FriendNotStateResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func fetchFriendTodoList(id: Int64) -> AnyPublisher<[FetchFrienTodoListResponse], Error> {
        return API.session.request(FriendTarget.fetchFriendTodoList(id), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [FetchFrienTodoListResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func addFriend(id: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(FriendTarget.addFriend(id), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard response.error == nil else {
                    throw response.error!
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func acceptFriend(id: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(FriendTarget.acceptFriend(id), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard response.error == nil else {
                    throw response.error!
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func deleteFriend(id: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(FriendTarget.deleteFriend(id), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                guard response.error == nil else {
                    throw response.error!
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
}

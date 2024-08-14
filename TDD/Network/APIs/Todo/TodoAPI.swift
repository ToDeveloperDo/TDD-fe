//
//  TodoAPI.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Combine
import Alamofire


final class TodoAPI {
    func createTodo(request: CreateTodoRequest) -> AnyPublisher<Int64, Error> {
        return API.session.request(TodoAPITarget.createTodo(request), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishString()
            .value()
            .map { Int64(Int($0) ?? -1) }
            .mapError({ error in
                return error
            })
            .eraseToAnyPublisher()
    }
    
    func getTodoList(request: GetTodoListRequest) -> AnyPublisher<[GetTodoListResponse], Error> {
        return API.session.request(TodoAPITarget.getTodoList(request), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [GetTodoListResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func getTodoCount(request: GetTodoCountRequest) -> AnyPublisher<[GetTodoCountResponse], Error> {
        return API.session.request(TodoAPITarget.getTodoCount(request), interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [GetTodoCountResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func reverseTodo(request: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(TodoAPITarget.reverseTodo(request), interceptor: AuthInterceptor.shared)
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
    
    func doneTodo(request: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(TodoAPITarget.doneTodo(request), interceptor: AuthInterceptor.shared)
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
    
    func editTodo(id: Int64, request: CreateTodoRequest) -> AnyPublisher<Bool, Error> {
        return API.session.request(TodoAPITarget.editTodo(id, request), interceptor: AuthInterceptor.shared)
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
    
    func deleteTodo(id: Int64) -> AnyPublisher<Bool, Error> {
        return API.session.request(TodoAPITarget.deleteTodo(id), interceptor: AuthInterceptor.shared)
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

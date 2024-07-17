//
//  TodoAPI.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Combine
import Alamofire


struct TodoAPI {
    static func createTodo(request: CreateTodoRequest) -> AnyPublisher<String, Error> {
        return API.session.request(TodoAPITarget.createTodo(request), interceptor: AuthInterceptor())
            .publishString()
            .value()
            .map { receivedValue in
                return receivedValue
            }
            .mapError({ error in
                return error
            })
            .eraseToAnyPublisher()
    }
}

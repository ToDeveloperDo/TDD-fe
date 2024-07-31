//
//  TodoService.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation
import Combine

protocol TodoServiceType {
    func createTodo(content: String, memo: String?, tag: String?, deadline: String) -> AnyPublisher<Int, ServiceError>
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError>
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError>
    func reverseTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError>
    func doneTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError>
    
}

final class TodoService: TodoServiceType {
    private var todoAPI: TodoAPI
    
    init(todoAPI: TodoAPI) {
        self.todoAPI = todoAPI
    }
    
    func createTodo(content: String, memo: String?, tag: String?, deadline: String) -> AnyPublisher<Int, ServiceError> {
        let request = CreateTodoRequest(content: content, memo: memo, tag: tag, deadline: deadline)
        return todoAPI.createTodo(request: request)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError> {
        let request = GetTodoListRequest(deadline: date)
        return todoAPI.getTodoList(request: request)
            .map { $0.map { $0.toModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError> {
        let Iyear = Int(year) ?? -1
        let Imonth = Int(month) ?? -1
        let request = GetTodoCountRequest(year: Iyear, month: Imonth)
        return todoAPI.getTodoCount(request: request)
            .map {
                $0.map {
                    var day = -1
                    let component = $0.deadline.split(separator: "-")
                    if component.count == 3 {
                        day = Int(String(component[2]))!
                    }
                    return (day, $0.count)
                }
            }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func reverseTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError> {
        return todoAPI.reverseTodo(request: todoId)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func doneTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError> {
        return todoAPI.doneTodo(request: todoId)
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubTodoService: TodoServiceType {
    func createTodo(content: String, memo: String?, tag: String?, deadline: String) -> AnyPublisher<Int, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError> {
        Just([(27, 2)]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func reverseTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func doneTodo(todoId: Int) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
}

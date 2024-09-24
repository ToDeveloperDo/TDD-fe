//
//  TodoService.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation
import Combine

protocol TodoServiceType {
    func createTodo(todo: Todo) -> AnyPublisher<Int64, ServiceError>
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError>
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError>
    func reverseTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError>
    func doneTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError>
    func editTodo(todo: Todo) -> AnyPublisher<Void, ServiceError>
    func deleteTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError>
}

final class TodoService: TodoServiceType {
    func createTodo(todo: Todo) -> AnyPublisher<Int64, ServiceError> {
        let request = CreateTodoRequest(content: todo.content, memo: todo.memo, tag: todo.tag, deadline: todo.deadline)
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.createTodo(request), type: Int64.self)
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
    
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError> {
        let request = GetTodoListRequest(deadline: date)
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.getTodoList(request), type: [GetTodoListResponse].self)
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
    
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError> {
        let Iyear = Int(year) ?? -1
        let Imonth = Int(month) ?? -1
        let request = GetTodoCountRequest(year: Iyear, month: Imonth)
        
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.getTodoCount(request), type: [GetTodoCountResponse].self)
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
    
    func reverseTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.reverseTodo(todoId), type: EmptyResponse.self)
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
    
    func doneTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.doneTodo(todoId), type: EmptyResponse.self)
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
    
    func editTodo(todo: Todo) -> AnyPublisher<Void, ServiceError> {
        let request = CreateTodoRequest(content: todo.content, memo: todo.memo, tag: todo.memo, deadline: todo.deadline)
        guard let id = todo.todoListId else { return Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher() }
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.editTodo(id, request), type: EmptyResponse.self)
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
    
    func deleteTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(TodoAPITarget.deleteTodo(todoId), type: EmptyResponse.self)
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

final class StubTodoService: TodoServiceType {
    func createTodo(todo: Todo) -> AnyPublisher<Int64, ServiceError> {
        Just(1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getTodoList(date: String) -> AnyPublisher<[Todo], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getTodoCount(year: String, month: String) -> AnyPublisher<[(Int, Int)], ServiceError> {
        Just([(27, 2)]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func reverseTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func doneTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()

    }
    
    func editTodo(todo: Todo) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func deleteTodo(todoId: Int64) -> AnyPublisher<Void, ServiceError> {
        Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}

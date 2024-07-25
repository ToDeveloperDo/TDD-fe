//
//  TodoAPITarget.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Alamofire

enum TodoAPITarget {
    case createTodo(CreateTodoRequest)
    case getTodoList(GetTodoListRequest)
    case getTodoCount(GetTodoCountRequest)
    case reverseTodo(Int)
    case doneTodo(Int)
    case editTodo(Int, CreateTodoRequest)
}

extension TodoAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createTodo: return .post
        case .getTodoList: return .post
        case .getTodoCount: return .post
        case .reverseTodo: return .patch
        case .doneTodo: return .patch
        case .editTodo: return .patch
        }
    }
    
    var path: String {
        switch self {
        case .createTodo: return "/api/todo"
        case .getTodoList: return "/api/todo/list"
        case .getTodoCount: return "/api/todo/count"
        case .reverseTodo: return "/api/todo/proceed/"
        case .doneTodo: return "/api/todo/done/"
        case .editTodo(let id, _): return "/api/todo/change/\(id)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createTodo(let request): return .body(request)
        case .getTodoList(let request): return .body(request)
        case .getTodoCount(let request): return .body(request)
        case .reverseTodo(let id): return .query(id)
        case .doneTodo(let id): return .query(id)
        case .editTodo(_, let request): return .body(request)
        }
    }
    
    
}

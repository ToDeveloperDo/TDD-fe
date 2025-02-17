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
    case reverseTodo(Int64)
    case doneTodo(Int64)
    case editTodo(Int64, TodoRequest)
    case deleteTodo(Int64)
}

extension TodoAPITarget: TargetType {
    var baseURL: String {
        // 서비스
        return "https://api.todeveloperdo.shop"
        
        // 개발
//        return "https://dev.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createTodo: return .post
        case .getTodoList: return .post
        case .getTodoCount: return .post
        case .reverseTodo: return .patch
        case .doneTodo: return .patch
        case .editTodo: return .patch
        case .deleteTodo: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createTodo: return "/api/todo"
        case .getTodoList: return "/api/todo/list"
        case .getTodoCount: return "/api/todo/count"
        case .reverseTodo(let id): return "/api/todo/proceed/\(id)"
        case .doneTodo(let id): return "/api/todo/done/\(id)"
        case .editTodo(let id, _): return "/api/todo/change/\(id)"
        case .deleteTodo(let id): return "/api/todo/\(id)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createTodo(let request): return .body(request)
        case .getTodoList(let request): return .body(request)
        case .getTodoCount(let request): return .body(request)
        case .reverseTodo: return .empty
        case .doneTodo: return .empty
        case .editTodo(_, let request): return .body(request)
        case .deleteTodo: return .empty
        }
    }
    
    
}

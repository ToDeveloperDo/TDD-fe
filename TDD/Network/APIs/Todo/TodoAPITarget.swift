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
}

extension TodoAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createTodo: return .post
        case .getTodoList: return .post
        }
    }
    
    var path: String {
        switch self {
        case .createTodo: return "/api/todo"
        case .getTodoList: return "/api/todo/list"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createTodo(let request): return .body(request)
        case .getTodoList(let request): return .body(request)
        }
    }
    
    
}

//
//  GetTodoListResponse.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation

struct GetTodoListResponse: Decodable {
    let todoListId: Int64
    let content: String
    let memo: String?
    let tag: String
    let deadline: String
    let todoStatus: TodoStatus
    
    func toModel() -> Todo {
        return Todo(todoListId: todoListId,
                    content: content,
                    memo: memo ?? "",
                    tag: tag,
                    deadline: deadline, 
                    status: todoStatus)
    }
}

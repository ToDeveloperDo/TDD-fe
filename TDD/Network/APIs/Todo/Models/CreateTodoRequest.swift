//
//  CreateTodoRequest.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation

struct CreateTodoRequest: Encodable {
    let todos: [TodoRequest]
}

struct TodoRequest: Encodable {
    let content: String
    let memo: String?
    let tag: String
    let deadline: String
}

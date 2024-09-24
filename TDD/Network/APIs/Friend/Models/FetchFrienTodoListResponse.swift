//
//  FetchFrienTodoListResponse.swift
//  TDD
//
//  Created by 최안용 on 8/19/24.
//

import Foundation

struct FetchFriendTodoListResponse: Decodable {
    let deadline: String
    let todoResponse: [GetTodoListResponse]
}

extension FetchFriendTodoListResponse {
    func toModel() -> FriendTodoList {
        .init(deadline: deadline, todos: todoResponse.map { $0.toModel() })
    }
}

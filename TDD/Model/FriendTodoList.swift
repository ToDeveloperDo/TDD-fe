//
//  FriendTodos.swift
//  TDD
//
//  Created by 최안용 on 8/18/24.
//

import Foundation

struct FriendTodoList: Identifiable {
    let id = UUID().uuidString
    let deadline: String
    let todos: [Todo]
    
    var title: String {
        let component = deadline.split(separator: "-")
        return "\(component[0])년 \(component[1])월 \(component[2])일"
    }
}

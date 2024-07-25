//
//  Month.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

struct Month: Identifiable {
    var id = UUID().uuidString
    var days: [Day]
    var selectedDayIndex: Int
}

struct Day: Identifiable {
    var id = UUID().uuidString
    var days: Int
    var date: Date
    var todos: [Todo] = []
    var todosCount: Int = 0
}

struct Todo: Identifiable, Equatable {
    var id = UUID().uuidString
    var todoListId: Int
    var content: String
    var memo: String
    var tag: String
    var status: TodoStatus
}

enum TodoStatus: Codable {
    case PROCEED
    case DONE
}

extension Todo {
    static let stub1 = Todo(todoListId: 1, content: "축구", memo: "아", tag: "아", status: .DONE)
    static let stub2 = Todo(todoListId: 1, content: "공부", memo: "아", tag: "아", status: .PROCEED)
}

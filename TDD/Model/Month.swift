//
//  Month.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

struct Month {
    var days: [Day]
    var selectedDay: Date
}

struct Day {
    var request: Bool = false
    var update: Bool = false
    let days: Int
    let date: Date
    var isCurrentMonthDay: Bool = true
    var todosCount: Int = 0
    var todos: [Todo] = []
}

struct Todo: Identifiable, Equatable {
    let id = UUID().uuidString
    var todoListId: Int64?
    var content: String
    var memo: String
    var tag: String
    var deadline: String
    var status: TodoStatus
}

enum TodoStatus: String, Codable {
    case PROCEED
    case DONE
}

extension Todo {
    static let stub1 = Todo(content: "축구", memo: "아", tag: "아", deadline: "2024-07-31", status: .DONE)
    static let stub2 = Todo(content: "공부", memo: "아", tag: "아", deadline: "2024-07-31", status: .PROCEED)
}

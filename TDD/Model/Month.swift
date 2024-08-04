//
//  Month.swift
//  TDD
//
//  Created by 최안용 on 7/12/24.
//

import Foundation

struct Month: Identifiable {
    let id = UUID().uuidString
    let month: String
    var days: [Day]
    var selectedDayIndex: Int
}

struct Day: Identifiable {
    let id = UUID().uuidString
    var days: Int
    var date: Date
    var todos: [Todo] = []
    var todosCount: Int = 0
}

struct Todo: Identifiable, Equatable {
    let id = UUID().uuidString
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
    static let stub1 = Todo(content: "축구", memo: "아", tag: "아", deadline: "2024-07-31", status: .PROCEED)
    static let stub2 = Todo(content: "공부", memo: "아", tag: "아", deadline: "2024-07-31", status: .PROCEED)
}

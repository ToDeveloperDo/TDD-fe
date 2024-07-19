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
    var selectedDay: Day
}

struct Day: Identifiable {
    var id = UUID().uuidString
    var days: Int
    var date: Date
    var todos: [Todo]
}

struct Todo: Hashable {
    var todoListId: Int
    var content: String
    var memo: String
    var tag: String
}


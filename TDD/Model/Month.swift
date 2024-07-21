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
    var todos: [Todo]
}

struct Todo: Identifiable, Hashable {
    var id = UUID().uuidString
    var todoListId: Int
    var content: String
    var memo: String
    var tag: String
}


//
//  TodoDetailViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/3/24.
//

import Foundation

enum AlertType {
    case edit
    case delete
}

final class TodoDetailViewModel: ObservableObject {
    @Published var todo: Todo
    @Published var changeDate: Date {
        didSet {
            todo.deadline = changeDate.format("YYYY-MM-dd")
        }
    }
    @Published var isPresent: Bool = false
    
    var alert: AlertType = .edit
    
    init(todo: Todo, date: Date) {
        self.todo = todo
        self.changeDate = date
    }
}

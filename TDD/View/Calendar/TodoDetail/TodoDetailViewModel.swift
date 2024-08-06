//
//  TodoDetailViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/3/24.
//

import Foundation

final class TodoDetailViewModel: ObservableObject {
    @Published var todo: Todo
    @Published var changeDate: Date {
        didSet {
            todo.deadline = changeDate.format("YYYY-MM-dd")
        }
    }
    @Published var isPresent: Bool = false
    
    private var container: DIContainer
    
    init(todo: Todo, container: DIContainer, date: Date) {
        self.todo = todo
        self.container = container
        self.changeDate = date
    }
}

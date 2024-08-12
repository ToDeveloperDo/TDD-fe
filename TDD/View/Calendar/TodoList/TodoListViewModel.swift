//
//  TodoListViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/8/24.
//

import Foundation
import Combine

final class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo]
    @Published var todosCount: Int
    
    init(todos: [Todo], todosCount: Int) {
        self.todos = todos
        self.todosCount = todosCount
    }
}


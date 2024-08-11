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
    @Published var date: Date
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(todos: [Todo]  = [], date: Date, container: DIContainer) {
        self.todos = todos
        self.date = date
        self.container = container
        fetchTodos()
    }
    
    
}

extension TodoListViewModel {
    private func fetchTodos() {
        container.services.todoService.getTodoList(date: date.format("YYYY-MM-DD"))
            .sink { completion in
                
            } receiveValue: { value in
                self.todos = value
            }

    }
}

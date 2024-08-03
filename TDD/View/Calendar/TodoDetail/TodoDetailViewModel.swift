//
//  TodoDetailViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/3/24.
//

import Foundation

final class TodoDetailViewModel: ObservableObject {
    @Published var todo: Todo
    
    private var container: DIContainer
    
    init(todo: Todo, container: DIContainer) {
        self.todo = todo
        self.container = container
    }
}

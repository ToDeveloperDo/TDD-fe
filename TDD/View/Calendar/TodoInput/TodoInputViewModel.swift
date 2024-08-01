//
//  TodoInputViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/1/24.
//

import Foundation

final class TodoInputViewModel: ObservableObject {
    @Published var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
}

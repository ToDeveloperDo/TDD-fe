//
//  TodoInputViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/1/24.
//

import Foundation

final class TodoInputViewModel: ObservableObject {
    @Published var todo: Todo
    
    let dateStr: String
    
    init(todo: Todo, date: Date) {
        self.todo = todo
        self.dateStr = date.format("YYYY년 MM월 dd일")
    }
}

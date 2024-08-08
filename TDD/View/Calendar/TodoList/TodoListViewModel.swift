//
//  TodoListViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/8/24.
//

import Foundation

final class TodoListViewModel: ObservableObject {
    @Published var todos = [String:[Todo]]()
}

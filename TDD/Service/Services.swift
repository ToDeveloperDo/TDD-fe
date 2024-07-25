//
//  Services.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

protocol ServiceType {
    var todoService: TodoServiceType { get set }
}

final class Services: ServiceType {
    var todoService: TodoServiceType
    
    init() {
        self.todoService = TodoService(todoAPI: TodoAPI())
    }
}


final class StubService: ServiceType {
    var todoService: TodoServiceType = StubTodoService()
}

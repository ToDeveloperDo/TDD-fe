//
//  Services.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

protocol ServiceType {
    var todoService: TodoServiceType { get set }
    var authService: AuthenticationServiceType { get set }
}

final class Services: ServiceType {
    var todoService: TodoServiceType
    var authService: AuthenticationServiceType
    
    init() {
        self.todoService = TodoService(todoAPI: TodoAPI())
        self.authService = AuthenticationService(authAPI: AuthAPI())
    }
}


final class StubService: ServiceType {
    var todoService: TodoServiceType = StubTodoService()
    var authService: AuthenticationServiceType = StubAuthenticationService()
}

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
    var githubService: GitHubSericeType { get set }
}

final class Services: ServiceType {
    var todoService: TodoServiceType
    var authService: AuthenticationServiceType
    var githubService: GitHubSericeType
    
    init() {
        self.todoService = TodoService(todoAPI: TodoAPI())
        self.authService = AuthenticationService(authAPI: AuthAPI())
        self.githubService = GitHubService(githubAPI: GitHubAPI())
    }
}


final class StubService: ServiceType {
    var todoService: TodoServiceType = StubTodoService()
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var githubService: GitHubSericeType = StubGitHubService()
}

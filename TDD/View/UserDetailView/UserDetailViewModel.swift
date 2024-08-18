//
//  UserDetailViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/17/24.
//

import Foundation

final class UserDetailViewModel: ObservableObject {
    @Published var userTodoList: [FriendTodoList]
    var user: UserInfo
    private var container: DIContainer
    
    init(userTodoList: [FriendTodoList] = [], user: UserInfo, container: DIContainer) {
        self.userTodoList = userTodoList
        self.user = user
        self.container = container
    }
    
    enum Action {
        case pop
    }
    
    func send(action: Action) {
        switch action {
        case .pop:
            container.navigationRouter.pop()
        }
    }
}

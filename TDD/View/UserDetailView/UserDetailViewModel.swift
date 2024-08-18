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
    var parent: NavigationRouterType
    private var container: DIContainer
    
    init(userTodoList: [FriendTodoList] = [], user: UserInfo, parent: NavigationRouterType, container: DIContainer) {
        self.userTodoList = userTodoList
        self.user = user
        self.parent = parent
        self.container = container
    }
    
    enum Action {
        case pop
    }
    
    func send(action: Action) {
        switch action {
        case .pop:
            container.navigationRouter.pop(on: parent)
        }
    }
}

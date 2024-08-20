//
//  UserDetailViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/17/24.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    @Published var userTodoList: [FriendTodoList]
    @Published var isLoading: Bool = false
    @Published var isPresentGit: Bool = false
    @Published var user: UserInfo
    
    var parent: NavigationRouterType
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(userTodoList: [FriendTodoList] = [], user: UserInfo, parent: NavigationRouterType, container: DIContainer) {
        self.userTodoList = userTodoList
        self.user = user
        self.parent = parent
        self.container = container
        fetchTodo()
    }
    
    enum Action {
        case pop
        case infoTypeBtnClicked
    }
    
    func send(action: Action) {
        switch action {
        case .pop:
            container.navigationRouter.pop(on: parent)
        case .infoTypeBtnClicked:
            switch user.status {
            case .FOLLOWING:
                user.status = .NOT_FRIEND
                container.services.friendService.deleteFriend(id: user.userId)
                    .sink { completion in
                        
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)

            case .NOT_FRIEND:
                user.status = .REQUEST
                container.services.friendService.addFriend(id: user.userId)
                    .sink { completion in
                        
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)
            case .REQUEST: break
            case .RECEIVE:
                user.status = .FOLLOWING
                container.services.friendService.acceptFriend(id: user.userId)
                    .sink { completion in
                        
                    } receiveValue: { succeed in
                        
                    }.store(in: &subscriptions)
            }
        }
        
    }
}

extension UserDetailViewModel {
    private func fetchTodo() {
        isLoading = true
        container.services.friendService.fetchFriendTodoList(id: user.userId)
            .sink { completion in
                
            } receiveValue: { [weak self] values in
                guard let self = self else { return }
                self.userTodoList = values
                self.isLoading = false
            }.store(in: &subscriptions)

    }
}

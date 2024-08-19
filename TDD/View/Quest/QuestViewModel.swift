//
//  QuestViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Combine

final class QuestViewModel: ObservableObject {
    @Published var searchName: String
    @Published var users: [UserInfo]
    @Published var isLoading: Bool = false
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchName: String = "", users: [UserInfo] = [], container: DIContainer) {
        self.searchName = searchName
        self.users = users
        self.container = container
    }
    
    
}

extension QuestViewModel {
    func fetchMembers() {
        self.isLoading = true
        container.services.memberService.fetchAllMember()
            .sink { completion in
                
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.users = users
                self.isLoading = false
            }.store(in: &subscriptions)
    }
    
    func accept(id: Int64) {
        container.services.friendService.acceptFriend(id: id)
            .sink { completion in
                
            } receiveValue: { succeed in
                
            }.store(in: &subscriptions)

    }
    
    func send(id: Int64) {
        container.services.friendService.addFriend(id: id)
            .sink { completion in
                
            } receiveValue: { succeed in
                
            }.store(in: &subscriptions)

    }
     func clickedUserCell(_ user: UserInfo) {
         container.navigationRouter.push(to: .userDetail(user: user, parent: .quest), on: .quest)
    }
}

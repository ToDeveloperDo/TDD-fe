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
    @Published var isPresentGit: Bool = false
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    var clickedGitUrl: String = ""
    
    init(searchName: String = "", users: [UserInfo] = [], container: DIContainer) {
        self.searchName = searchName
        self.users = users
        self.container = container
    }
    
    enum Action {
        case clickedInfoType(user: UserInfo)
    }
    
    func send(action: Action) {
        switch action {
        case .clickedInfoType(let user):
            clickedUserInfoBtn(user: user)
            
        }
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

    func clickedUserCell(_ user: UserInfo) {
        container.navigationRouter.push(to: .userDetail(user: user, parent: .quest), on: .quest)
    }
    
    private func clickedUserInfoBtn(user: UserInfo) {
        guard let index = users.firstIndex(where: { $0.userId == user.userId }) else { return }
        switch user.status {
        case .FOLLOWING:
            container.services.friendService.deleteFriend(id: user.userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] succeed in
                    guard let self = self else { return }
                    self.users[index].status = .NOT_FRIEND
                }.store(in: &subscriptions)
            
        case .NOT_FRIEND:
            container.services.friendService.addFriend(id: user.userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] succeed in
                    guard let self = self else { return }
                    self.users[index].status = .REQUEST
                }.store(in: &subscriptions)
        case .REQUEST:break
        case .RECEIVE:
            container.services.friendService.acceptFriend(id: user.userId)
                .sink { completion in
                    
                } receiveValue: { [weak self] succeed in
                    guard let self = self else { return }
                    self.users[index].status = .FOLLOWING
                }.store(in: &subscriptions)
        }
    }
}

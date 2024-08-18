//
//  MyProfileViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation
import Combine

final class MyProfileViewModel: ObservableObject {
    @Published var searchName: String
    @Published var myInfo: MyInfo?
    @Published var users: [UserInfo]
    @Published var selectedMode: MyProfileBtnType = .friend 
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    enum Action {
        case clickedBtn(mode: MyProfileBtnType)
        case clickedUserCell(user: UserInfo)
    }
    
    init(searchName: String = "",
         users: [UserInfo] = [],
         container: DIContainer) {
        self.searchName = searchName
        self.users = users
        self.container = container
        fetchMyInfo()
        clickedBtn(.friend)
    }
    
    func send(action: Action) {
        switch action {
        case .clickedBtn(let mode):
            clickedBtn(mode)
        case .clickedUserCell(let user):
            clickedUserCell(user)
        }
    }
    
}

extension MyProfileViewModel {
    private func clickedUserCell(_ user: UserInfo) {
        container.navigationRouter.push(to: .userDetail(user: user))
    }
    
    private func fetchMyInfo() {
        container.services.memberService.fetchMyInfo()
            .sink { completion in
                
            } receiveValue: { [weak self]  myInfo in
                guard let self = self else { return }
                self.myInfo = myInfo
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
}

extension MyProfileViewModel {
    private func clickedBtn(_ mode: MyProfileBtnType) {
        selectedMode = mode
        
        switch mode {
        case .friend:
            container.services.friendService.fetchFriendList()
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.users = users
                }.store(in: &subscriptions)

        case .request:
            container.services.friendService.fetchSendList()
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.users = users
                }.store(in: &subscriptions)
        case .receive:
            container.services.friendService.fetchReceiveList()
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.users = users
                }.store(in: &subscriptions)
        }
    }
}

//
//  MyProfileViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation
import Combine

final class MyProfileViewModel: ObservableObject {
    @Published var searchName: String {
        didSet {
            if searchName == "" {
                userListMode = .normal
            }
        }
    }
    @Published var userListMode: Mode = .normal
    @Published var myInfo: MyInfo?
    @Published var users: [UserInfo]
    @Published var searchUsers: [UserInfo]
    @Published var selectedMode: MyProfileBtnType = .friend
    @Published var isPresentGit: Bool = false
    @Published var isLoading: Bool = false
    @Published var isShowingAlert: Bool = false
    @Published var showAlert: InfoType = .FOLLOWING
    
    var clickedGitUrl: String = ""
    
    private var deleteMember: UserInfo?
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    enum Mode {
        case search
        case normal
    }
    
    enum Action {
        case clickedBtn(mode: MyProfileBtnType)
        case clickedUserCell(user: UserInfo)
        case clickedSetting
        case clickedUserInfoBtn(user: UserInfo)
        case searchUser
        case clickedCloseBtn(user: UserInfo)
        case deleteAction
    }
    
    init(searchName: String = "",
         users: [UserInfo] = [],
         searchUsers: [UserInfo] = [],
         container: DIContainer) {
        self.searchName = searchName
        self.users = users
        self.searchUsers = searchUsers
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
        case .clickedSetting:
            container.navigationRouter.push(to: .setting, on: .myProfile)
        case .clickedUserInfoBtn(let user):
            clickedUserInfoBtn(user: user)
        case .searchUser:
            searchUser()
        case .clickedCloseBtn(let user):
            deleteMember = user
            showAlert = user.status
            isShowingAlert = true
        case .deleteAction:
            deleteAction()
        }
    }
    
}

extension MyProfileViewModel {
    private func clickedUserCell(_ user: UserInfo) {
        container.navigationRouter.push(to: .userDetail(user: user, parent: .myProfile), on: .myProfile)
    }
    
    private func fetchMyInfo() {
        container.services.memberService.fetchMyInfo()
            .sink { completion in
                
            } receiveValue: { [weak self]  myInfo in
                guard let self = self else { return }
                self.myInfo = myInfo
            }.store(in: &subscriptions)

    }
}

extension MyProfileViewModel {
    private func clickedBtn(_ mode: MyProfileBtnType) {
        selectedMode = mode
        isLoading = true
        switch mode {
        case .friend:
            container.services.friendService.fetchFriendList()
                .sink { completion in
                    if case .failure(let error) = completion {
                       
                    }
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.users = users
                }.store(in: &subscriptions)
            
        case .request:
            container.services.friendService.fetchSendList()
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.users = users
                }.store(in: &subscriptions)
        case .receive:
            container.services.friendService.fetchReceiveList()
                .sink { completion in
                    
                } receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    self.isLoading = false
                    self.users = users
                }.store(in: &subscriptions)
        }
    }
    
    private func clickedUserInfoBtn(user: UserInfo) {
        if let userIndex = users.firstIndex(where: { $0.userId == user.userId }) {
            users.remove(at: userIndex)
            
            container.services.friendService.acceptFriend(id: user.userId)
                .sink { completion in
                    
                } receiveValue: { succeed in
                    
                }.store(in: &subscriptions)
        }
    }
    
    private func searchUser() {
        isLoading = true
        searchUsers = []
        userListMode = .search
        searchUsers = users.filter({$0.userName == searchName})
        isLoading = false
    }
    
    private func deleteAction() {
        guard let member = deleteMember else { return }
        container.services.friendService.deleteFriend(id: member.userId, type: member.status)
            .sink {  completion in
                
            } receiveValue: { [weak self] _ in
                if let userIndex = self?.users.firstIndex(where: {$0.userId == member.userId}) {
                    self?.users.remove(at: userIndex)
                }
            }.store(in: &subscriptions)

    }
}

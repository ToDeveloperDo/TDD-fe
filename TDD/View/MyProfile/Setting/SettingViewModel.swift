//
//  SettingViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/19/24.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
    @Published var isPresentAlert = false
    @Published var isLoading = false
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var authViewModel: AuthenticationViewModel
    
    init(container: DIContainer, authViewModel: AuthenticationViewModel) {
        self.container = container
        self.authViewModel = authViewModel
    }
    
    enum Action {
        case clickedRevoke
        case checkRevoke
        case teamIntroduction
        case personalInformation
        case pop
    }
    
    
    func send(action: Action) {
        switch action {
        case .clickedRevoke:
            isPresentAlert = true
        case .checkRevoke:
            isLoading = true
            authViewModel.send(action: .revokeWithApple)
        case .teamIntroduction:
            container.navigationRouter.push(to: .teamIntroduction, on: .myProfile)
        case .personalInformation:
            container.navigationRouter.push(to: .personalInformation, on: .myProfile)
        case .pop:
            container.navigationRouter.pop(on: .myProfile)
        }
    }
}

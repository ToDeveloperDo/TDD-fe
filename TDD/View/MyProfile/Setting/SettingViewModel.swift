//
//  SettingViewModel.swift
//  TDD
//
//  Created by 최안용 on 8/19/24.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    private var authViewModel: AuthenticationViewModel
    
    init(container: DIContainer, authViewModel: AuthenticationViewModel) {
        self.container = container
        self.authViewModel = authViewModel
    }
    
    func revoke() {
        authViewModel.send(action: .revokeWithApple)
    }
    
    func push() {
        container.navigationRouter.push(to: .teamIntroduction, on: .myProfile)
    }
    
    func pop() {
        container.navigationRouter.pop(on: .myProfile)
    }
}

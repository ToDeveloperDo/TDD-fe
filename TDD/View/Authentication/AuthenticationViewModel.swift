//
//  AuthenticationViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unAuthenticated
    case authenticated
}

final class AuthenticationViewModel: ObservableObject {
    @Published var authState: AuthenticationState = .authenticated
    @Published var authToken: String?
    @Published var isPresent: Bool = false
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case appleLogin(ASAuthorizationAppleIDRequest)
        case appleLoginCompletion(Result<ASAuthorization, Error>)
        case checkLoginState
    }
      
    func send(action: Action) {
        switch action {
        case .appleLogin(let request):
            container.services.authService.signInWithAppleRequest(request)
        case .appleLoginCompletion(let result):
            if case let .success(authorization) = result {
                container.services.authService.signInwithAppleCompletion(authorization)
                    .sink { [weak self] completion in
                        if case .failure(let error) = completion {
                            print("Error during sign-in completion: \(error)")
                            self?.authState = .unAuthenticated
                        }
                    } receiveValue: { [weak self] result in
                        guard let self = self else { return }
                        do {
                            try KeychainManager.shared.create(.access, input: result.0.idToken)
                            try KeychainManager.shared.create(.refresh, input: result.0.refreshToken)
                            try KeychainManager.shared.create(.userIdentifier, input: result.1)
                            self.authState = .authenticated
                        } catch {
                            self.authState = .unAuthenticated
                            self.isPresent = true
                            return
                        }
                    }.store(in: &subscription)

            } else if case .failure(_) = result {
                authState = .unAuthenticated
            }
        case .checkLoginState:
            let appleIDProvicer = ASAuthorizationAppleIDProvider()
            do {
                let userIdentifier = try KeychainManager.shared.getData(.userIdentifier)
                appleIDProvicer.getCredentialState(forUserID: userIdentifier) { [weak self](credentialState, error) in
                    DispatchQueue.main.async {
                        switch credentialState {
                        case .authorized:
                            self?.authState = .authenticated
                        case .revoked, .notFound:
                            self?.authState = .unAuthenticated
                        default:
                            self?.authState = .unAuthenticated
                        }
                    }
                }
            } catch {
                authState = .unAuthenticated
            }
        }
    }
}

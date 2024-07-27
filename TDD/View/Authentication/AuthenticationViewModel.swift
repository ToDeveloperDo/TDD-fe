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
    @Published var authState: AuthenticationState = .unAuthenticated
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
                        self.authState = .authenticated
                        print(result)
                    }.store(in: &subscription)

            } else if case .failure(_) = result {
                authState = .unAuthenticated
            }
        }
    }
//    func check() {
//        NotificationCenter.default.addObserver(forName: Notification.Name("GitHubLogin"), object: nil, queue: .main) { notification in
//            if let url = notification.object as? URL {
//                if let token = self.extractToken(from: url) {
//                    self.authToken = token
//                    self.isPresent = false
//                    self.authState = .authenticated
//                    print("Received JWT token: \(token)")
//                }
//            }
//        }
//    }
//    
//    private func extractToken(from url: URL) -> String? {
//        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//        return components?.queryItems?.first(where: { $0.name == "token"})?.value
//    }
}

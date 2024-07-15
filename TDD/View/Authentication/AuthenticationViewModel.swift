//
//  AuthenticationViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/10/24.
//

import Foundation

enum AuthenticationState {
    case unAuthenticated
    case authenticated
}

final class AuthenticationViewModel: ObservableObject {
    @Published var authState: AuthenticationState = .authenticated
    @Published var authToken: String?
    @Published var isPresent: Bool = false
    
    func check() {
        NotificationCenter.default.addObserver(forName: Notification.Name("GitHubLogin"), object: nil, queue: .main) { notification in
            if let url = notification.object as? URL {
                if let token = self.extractToken(from: url) {
                    self.authToken = token
                    self.isPresent = false
                    self.authState = .authenticated
                    print("Received JWT token: \(token)")
                }
            }
        }
    }
    
    private func extractToken(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "token"})?.value
    }
}

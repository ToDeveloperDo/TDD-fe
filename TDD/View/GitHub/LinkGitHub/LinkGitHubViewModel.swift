//
//  LinkGitHubViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/30/24.
//

import Foundation

final class LinkGitHubViewModel: ObservableObject {
    @Published var isPresent: Bool = false
    let url: URL
    let userId: String
    
    private var container: DIContainer
    
    init(container: DIContainer) {
        do {
            self.userId = try KeychainManager.shared.getData(.userIdentifier)
            self.url = URL(string: "https://api.todeveloperdo.shop/git/login?appleId=\(userId)")!            
        }catch {
            self.userId = ""
            self.url = URL(fileURLWithPath: "")
        }
        self.container = container
        check()
    }
    
        func check() {
            NotificationCenter.default.addObserver(forName: Notification.Name("GitHubLogin"), object: nil, queue: .main) { notification in
                if let url = notification.object as? URL {
                    if let token = self.extractToken(from: url) {
                        self.isPresent = false
                        self.container.navigationRouter.pop()
                    }
                }
            }
        }
    
        private func extractToken(from url: URL) -> String? {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            return components?.queryItems?.first(where: { $0.name == "token"})?.value
        }
}

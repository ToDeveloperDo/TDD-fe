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
    private var mainTabViewModel: MainTabViewModel
    
    init(container: DIContainer, mainTabViewModel: MainTabViewModel) {
        do {
            self.userId = try KeychainManager.shared.getData(.userIdentifier)
            self.url = URL(string: "https://api.todeveloperdo.shop/git/login?appleId=\(userId)")!            
        }catch {
            self.userId = ""
            self.url = URL(fileURLWithPath: "")
        }
        self.container = container
        self.mainTabViewModel = mainTabViewModel
        check()
    }
    
        func check() {
            NotificationCenter.default.addObserver(forName: Notification.Name("GitHubLogin"), object: nil, queue: .main) { [weak self] notification in
                guard let self = self else { return }
                if let url = notification.object as? URL {
                    if self.extractToken(from: url) != nil {
                        self.isPresent = false
                        self.mainTabViewModel.isPresentGitLink = false
                    }
                }
            }
        }
    
        private func extractToken(from url: URL) -> String? {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            return components?.queryItems?.first(where: { $0.name == "token"})?.value
        }
}

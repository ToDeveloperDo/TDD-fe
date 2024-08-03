//
//  MainTabViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/18/24.
//

import Foundation
import Combine

final class MainTabViewModel: ObservableObject {
    @Published var phase: Phase = .success
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case load
    }
    
    func send(action: Action) {
        switch action {
        case .load:
            loadAction()
        }
    }
    
    private func loadAction() {
        isGithubLink()
            .flatMap { [weak self] isLinked -> AnyPublisher<Bool, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()
                }
                if !isLinked {
                    self.container.navigationRouter.push(to: .createRepo)
                    self.container.navigationRouter.push(to: .linkGithub)
                    self.phase = .success
                    return Empty().eraseToAnyPublisher()
                } else {
                    return self.isRepoCreated()
                }
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion {
                    self?.phase = .fail
                }
            }, receiveValue: { [weak self] isRepoCreated in
                guard let self = self else { return }
                if !isRepoCreated {
                    self.container.navigationRouter.push(to: .createRepo)
                }
                self.phase = .success
            })
            .store(in: &subscription)
    }
}

extension MainTabViewModel {
    private func isGithubLink() -> AnyPublisher<Bool, Error> {
        container.services.githubService.isGitLink()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    private func isRepoCreated() -> AnyPublisher<Bool, Error> {
        container.services.githubService.isRepoCreated()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}

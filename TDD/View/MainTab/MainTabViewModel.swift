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
    @Published var isPresentGitLink = false
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    enum Action {
        case checkRepoCreate
        case checkGitLink
    }
    
    func send(action: Action) {
        switch action {
        case .checkRepoCreate:
            checkRepoCreate()
        case .checkGitLink:
            checkGitLink()
        }
    }
}

extension MainTabViewModel {
    private func checkRepoCreate() {
        phase = .loading
        container.services.githubService.isRepoCreated()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                    self?.phase = .fail
                }
            } receiveValue: { [weak self] succeed in
                guard let self = self else { return }
                if succeed {
                    self.phase = .success
                } else {
                    self.phase = .notCreateRepo
                }
            }
            .store(in: &subscription)
    }
    
    private func checkGitLink() {
        container.services.githubService.isGitLink()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                    self?.phase = .fail
                }
            } receiveValue: { [weak self] succeed in
                guard let self = self else { return }
                if !succeed {
                    self.isPresentGitLink = true
                }
            }
            .store(in: &subscription)
    }
}

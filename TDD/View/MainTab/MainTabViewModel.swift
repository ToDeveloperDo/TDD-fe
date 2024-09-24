//
//  MainTabViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/18/24.
//

import Foundation
import Combine

final class MainTabViewModel: ObservableObject {
    
    @Published var phase: Phase = .notRequest
    @Published var isPresentCreateRepo = false
    
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        bindingNotification()
    }
    
    enum Action {
        case checkGitLink
    }
    
    func send(action: Action) {
        switch action {
        case .checkGitLink:
            checkGitLink()
        }
    }
}

extension MainTabViewModel {
    private func bindingNotification() {
        NotificationCenter.default.publisher(for: .noRepository)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isPresentCreateRepo = true
            }.store(in: &subscription)

    }
    
    private func checkGitLink() {
        container.services.githubService.isGitLink()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.phase = .success
                case .failure(let error):
                    switch error {
                    case .notRepository:
                        break
                    case .serverError(let message):
                        print(message)
                        self?.phase = .fail
                    default:
                        self?.phase = .fail
                    }
                }
            } receiveValue: { [weak self] _ in
                self?.phase = .success
            }
            .store(in: &subscription)
    }
}

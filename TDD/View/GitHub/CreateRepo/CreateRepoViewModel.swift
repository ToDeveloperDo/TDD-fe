//
//  CreateRepoViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Combine

enum ShowAlert {
    case create
    case inputError
}

final class CreateRepoViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var isPrivate: Bool
    @Published var isPresentAlert: Bool
    @Published var isLoading: Bool = false
    
    var alert: ShowAlert = .create
    private var container: DIContainer
    private var mainTabViewModel: MainTabViewModel
    private var subscription = Set<AnyCancellable>()
    
    init(name: String = "",
         description: String = "",
         isPrivate: Bool = false,
         isPresentAlert: Bool =  false,
         mainTabViewModel: MainTabViewModel,
         container: DIContainer) {
        self.name = name
        self.description = description
        self.isPrivate = isPrivate
        self.isPresentAlert = isPresentAlert
        self.mainTabViewModel = mainTabViewModel
        self.container = container
    }
    
    func createRepo() {
        isLoading = true
        let request = CreateRepoRequest(repoName: name, description: description, isPrivate: isPrivate)
        
        container.services.githubService.createRepo(request: request)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(_) = completion {
                    self.isLoading = false
                    self.isPresentAlert = true
                    self.alert = .inputError
                    print(completion)
                }
            } receiveValue: { [weak self] succeed in
                guard let self = self else { return }
                if succeed {
                    self.isLoading = false
                    self.mainTabViewModel.phase = .success
                } else {
                    self.isLoading = false
                    self.isPresentAlert = true
                    self.alert = .inputError
                }
            }.store(in: &subscription)
    }
}

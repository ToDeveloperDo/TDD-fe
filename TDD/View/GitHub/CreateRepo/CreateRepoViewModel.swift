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
    
    var alert: ShowAlert = .create
    private var container: DIContainer
    private var subscription = Set<AnyCancellable>()
    
    init(name: String = "",
         description: String = "",
         isPrivate: Bool = true,
         isPresentAlert: Bool =  false,
         container: DIContainer) {
        self.name = name
        self.description = description
        self.isPrivate = isPrivate
        self.isPresentAlert = isPresentAlert
        self.container = container
    }
    
    func createRepo() {
        let request = CreateRepoRequest(repoName: name, description: description, isPrivate: isPrivate)
        
        container.services.githubService.createRepo(request: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    //Error
                    print(completion)
                }
            } receiveValue: { [weak self] succeed in
                guard let self = self else { return }
                if succeed {
                    self.container.navigationRouter.pop()
                }
            }.store(in: &subscription)
    }
}

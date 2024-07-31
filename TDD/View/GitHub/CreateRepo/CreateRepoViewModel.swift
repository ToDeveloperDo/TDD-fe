//
//  CreateRepoViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation

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
        container.navigationRouter.pop()
    }
}

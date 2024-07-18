//
//  CreateRepoViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation

final class CreateRepoViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var isPrivate: Bool
    
    private var container: DIContainer
    
    init(name: String = "",
         description: String = "",
         isPrivate: Bool = true,
         container: DIContainer) {
        self.name = name
        self.description = description
        self.isPrivate = isPrivate
        self.container = container
    }
    
    func createRepo() {
        container.navigationRouter.pop()
    }
}

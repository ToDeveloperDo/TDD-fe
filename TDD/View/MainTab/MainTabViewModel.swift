//
//  MainTabViewModel.swift
//  TDD
//
//  Created by 최안용 on 7/18/24.
//

import Foundation

final class MainTabViewModel: ObservableObject {
    private var container: DIContainer
    private var check: Bool = true
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func isRepo() {
        if check {
            self.container.navigationRouter.push(to: .linkGithub)
        }
    }
}

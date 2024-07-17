//
//  DIContainer.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

final class DIContainer: ObservableObject {
    var services: ServiceType
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    
    init(services: ServiceType,
         navigationRouter: NavigationRouter & ObservableObjectSettable = NavigationRouter()) {
        self.services = services
        self.navigationRouter = navigationRouter
        
        self.navigationRouter.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubService())
    }
}

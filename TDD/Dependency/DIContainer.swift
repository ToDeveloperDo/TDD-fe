//
//  DIContainer.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

final class DIContainer: ObservableObject {
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}

//
//  ServiceError.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation

enum ServiceError: Error {
    case error(Error)
    case authorizationFailed
}

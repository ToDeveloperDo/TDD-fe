//
//  NetworkError.swift
//  TDD
//
//  Created by 최안용 on 9/23/24.
//

import Foundation

enum NetworkError: Error {
    case error(Error)
    case serverError(String)
    case notRepository
}

//
//  ServerErrorResponse.swift
//  TDD
//
//  Created by 최안용 on 9/24/24.
//

import Foundation

struct ServerErrorResponse: Decodable {
    let message: String
    let code: String
}

//
//  GetTodoCountResponse.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation

struct GetTodoCountResponse: Decodable {
    let deadline: String
    let count: Int
}



//
//  GetTodoCountRequest.swift
//  TDD
//
//  Created by 최안용 on 7/25/24.
//

import Foundation

struct GetTodoCountRequest: Encodable {
    let year: Int
    let month: Int
}

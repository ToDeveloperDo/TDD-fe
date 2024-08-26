//
//  LoginRequest.swift
//  TDD
//
//  Created by 최안용 on 7/27/24.
//

import Foundation

struct LoginRequest: Encodable {
    let code: String
    let clientToken: String
}

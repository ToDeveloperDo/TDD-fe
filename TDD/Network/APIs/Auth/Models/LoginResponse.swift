//
//  LoginResponse.swift
//  TDD
//
//  Created by 최안용 on 7/27/24.
//

import Foundation

struct LoginResponse: Decodable {
    let idToken: String
    let refreshToken: String
}

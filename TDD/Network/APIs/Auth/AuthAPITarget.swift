//
//  AuthAPITarget.swift
//  TDD
//
//  Created by 최안용 on 7/27/24.
//

import Foundation
import Alamofire

enum AuthAPITarget {
    case signInWithApple(LoginRequest)
    case refreshToken(RefreshRequest)
}


extension AuthAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signInWithApple: return .post
        case .refreshToken: return .post
        }
    }
    
    var path: String {
        switch self {
        case .signInWithApple: return "/api/login/apple"
        case .refreshToken: return "/api/login/refresh"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .signInWithApple(let request): return .query(request)
        case .refreshToken(let request): return .body(request)
        }
    }
}

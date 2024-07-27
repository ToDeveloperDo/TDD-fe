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
}


extension AuthAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signInWithApple: return .post
        }
    }
    
    var path: String {
        switch self {
        // MARK: path 미정
        case .signInWithApple: return "/api/login/apple"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .signInWithApple(let request): return .body(request)
        }
    }
}

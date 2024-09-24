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
    case revokeWithApple
}


extension AuthAPITarget: TargetType {
    var baseURL: String {
        // 서비스
        return "https://api.todeveloperdo.shop"
        
        // 개발
//        return "https://dev.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signInWithApple: return .post
        case .refreshToken: return .post
        case .revokeWithApple: return .post
        }
    }
    
    var path: String {
        switch self {
        case .signInWithApple: return "/api/login/apple"
        case .refreshToken: return "/api/login/refresh"
        case .revokeWithApple: return "/api/apple"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .signInWithApple(let request): return .query(request)
        case .refreshToken(let request): return .body(request)
        case .revokeWithApple: return .empty
        }
    }
}

//
//  GitHubAPITarget.swift
//  TDD
//
//  Created by 최안용 on 7/22/24.
//

import Foundation
import Alamofire

enum GitHubAPITarget {
    case isGitLink
    case createRepo(CreateRepoRequest)
}

extension GitHubAPITarget: TargetType {
    var baseURL: String {
        // 서비스
        return "https://api.todeveloperdo.shop"
        
        // 개발
//        return "https://dev.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .isGitLink: return .get
        case .createRepo: return .post
        }
    }
    
    var path: String {
        switch self {
        case .isGitLink: return "/api/github/check"
        case .createRepo: return "/api/github/create/repo"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .isGitLink: return .empty
        case .createRepo(let request): return .body(request)
        }
    }
}

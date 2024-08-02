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
    case isRepoCreated
    case createRepo(CreateRepoRequest)
}

extension GitHubAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .isGitLink: return .post
        case .isRepoCreated: return .post
        case .createRepo: return .post
        }
    }
    
    var path: String {
        switch self {
        case .isGitLink: return "/api/github/check"
        case .isRepoCreated: return ""
        case .createRepo: return "/api/github/create/repo"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .isGitLink: return .body()
        case .isRepoCreated: return .body()
        case .createRepo(let request): return .body(request)
        }
    }
}

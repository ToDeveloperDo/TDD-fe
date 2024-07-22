//
//  RepoAPITarget.swift
//  TDD
//
//  Created by 최안용 on 7/22/24.
//

import Foundation
import Alamofire

enum RepoAPITarget {
    case createRepo(CreateRepoRequest)
}

extension RepoAPITarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createRepo: return .post
        }
    }
    
    var path: String {
        switch self {
        case .createRepo: return "/api/github/create/repo"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .createRepo(let request): return .body(request)
        }
    }
    
    
}

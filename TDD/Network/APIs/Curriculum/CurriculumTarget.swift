//
//  CurriculumTarget.swift
//  TDD
//
//  Created by 최안용 on 11/10/24.
//

import Foundation

import Alamofire

enum CurriculumTarget {
    case makeCurriculum(request: MakeCurriculumRequest)
}

extension CurriculumTarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .makeCurriculum: return .post
        }
    }
    
    var path: String {
        switch self {
        case .makeCurriculum: return "api/recommend/curriculum"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .makeCurriculum(let request): .body(request)
        }
    }
}

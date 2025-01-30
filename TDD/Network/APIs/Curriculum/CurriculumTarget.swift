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
    case saveCurriculum(request: RegisterReqeust)
    case fetchCurriculum(id: Int)
    case fetchPlan
}

extension CurriculumTarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .makeCurriculum: return .post
        case .saveCurriculum: return .post
        case .fetchCurriculum: return .get
        case .fetchPlan: return .get
        }
    }
    
    var path: String {
        switch self {
        case .makeCurriculum: return "api/curriculum/recommend"
        case .saveCurriculum: return "api/curriculum/save"
        case .fetchCurriculum(let id): return "api/curriculum/\(id)"
        case .fetchPlan: return "/api/plan"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .makeCurriculum(let request): .body(request)
        case .saveCurriculum(let request): .body(request)
        case .fetchCurriculum: .empty
        case .fetchPlan: .empty
        }
    }
}

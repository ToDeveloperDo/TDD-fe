//
//  MemberTarget.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Alamofire

enum MemberTarget {
    case fetchMyInfo
    case fetchAllMember
}

extension MemberTarget: TargetType {
    var baseURL: String {
        return "https://api.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchMyInfo: return .get
        case .fetchAllMember: return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyInfo: return "/api/member"
        case .fetchAllMember: return "api/member/all"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyInfo: .empty
        case .fetchAllMember: .empty
        }
    }
}


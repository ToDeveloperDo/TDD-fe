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
    case updateFcmToken(token: FCMTokenRequest)
}

extension MemberTarget: TargetType {
    var baseURL: String {
        // 서비스
        return "https://api.todeveloperdo.shop"
        
        // 개발
//        return "https://dev.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchMyInfo: return .get
        case .fetchAllMember: return .get
        case .updateFcmToken: return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyInfo: return "/api/member"
        case .fetchAllMember: return "api/member/all"
        case .updateFcmToken: return "/api/member/fcm"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .fetchMyInfo: .empty
        case .fetchAllMember: .empty
        case .updateFcmToken(let request): .body(request)
        }
    }
}


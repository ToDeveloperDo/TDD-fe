//
//  InfoType.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import Foundation

enum InfoType: String, Codable {
    case FOLLOWING // 친구 상태
    case NOT_FRIEND // 모르는 사람
    case REQUEST // 친구 요청을 보낸 사람
    case RECEIVE // 친구 요청을 받은 사람
    
    var title: String {
        switch self {
        case .FOLLOWING:
            return "팔로잉"
        case .NOT_FRIEND:
            return "팔로우"
        case .REQUEST:
            return "요청됨"
        case .RECEIVE:
            return "수락하기"
        }
    }
    
    var titleColor: String {
        switch self {
        case .FOLLOWING:
            return "primary100"
        case .NOT_FRIEND:
            return "fixBk"
        case .REQUEST:
            return "fixWh"
        case .RECEIVE:
            return "fixWh"
        }
    }
    
    var bgColor: String {
        switch self {
        case .FOLLOWING:
            return "mainbg"
        case .NOT_FRIEND:
            return "primary50"
        case .REQUEST:
            return "primary100"
        case .RECEIVE:
            return "black50"
        }
    }
    
    var deleteString: String {
        switch self {
        case .FOLLOWING:
            return "FOLLOWING"
        case .NOT_FRIEND, .RECEIVE, .REQUEST:
            return "NOT_FRIEND"
        }
    }
}

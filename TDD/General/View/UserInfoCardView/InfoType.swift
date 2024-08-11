//
//  InfoType.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import Foundation

enum InfoType: String {
    case following // 친구 상태
    case follow // 모르는 사람
    case request // 친구 요청을 보낸 사람
    case accept // 친구 요청을 받은 사람
    
    var title: String {
        switch self {
        case .following:
            return "팔로잉"
        case .follow:
            return "팔로우"
        case .request:
            return "요청됨"
        case .accept:
            return "수락하기"
        }
    }
    
    var titleColor: String {
        switch self {
        case .following:
            return "mainColor"
        case .follow:
            return "fixWh"
        case .request:
            return "cardBtnTextGray"
        case .accept:
            return "fixWh"
        }
    }
    
    var bgColor: String {
        switch self {
        case .following:
            return "mainbg"
        case .follow:
            return "mainColor"
        case .request:
            return "cardBtnGray"
        case .accept:
            return "mainColor"
        }
    }
}

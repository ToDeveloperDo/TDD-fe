//
//  InfoType.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import Foundation

enum InfoType: String {
    case following
    case follow
    case request
    case accept
    
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

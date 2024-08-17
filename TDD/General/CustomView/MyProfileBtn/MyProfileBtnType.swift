//
//  MyProfileBtnType.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation

enum MyProfileBtnType {
    case friend
    case request
    case receive
    
    var title: String {
        switch self {
        case .friend:
            return "친구 목록"
        case .request:
            return "보낸 요청"
        case .receive:
            return "받은 요청"
        }
    }
    
    var emptyTitle: String {
        switch self {
        case .friend: return "등록된 친구가 없어요"
        case .request: return "보낸 요청이 없어요"
        case .receive: return "받은 요청이 없어요"
        }
    }
    
    var imageName: String {
        switch self {
        case .friend: return "friendEmpty"
        case .request: return "sendEmpty"
        case .receive: return "receiveEmpty"
        }
    }
}

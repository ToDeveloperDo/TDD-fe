//
//  MyInfoBtnType.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation

enum MyInfoBtnType {
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
}

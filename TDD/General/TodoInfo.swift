//
//  TodoInfo.swift
//  TDD
//
//  Created by 최안용 on 8/4/24.
//

import Foundation

enum TodoInfo: String {
    case date = "날짜"
    case isDone = "달성"
    case tag = "태그"
    
    var imageName: String {
        switch self {
        case .date:
            return "ic_detailcalendar"
        case .isDone:
            return "ic_checkBox"
        case .tag:
            return "ic_tag"
        }
    }
}

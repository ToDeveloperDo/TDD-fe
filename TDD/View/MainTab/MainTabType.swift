//
//  MainTabType.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case calendar
    case quest
    case myInfo
    
    var title: String {
        switch self {
        case .calendar:
            return "캘린더"
        case .quest:
            return "탐색"
        case .myInfo:
            return "내 정보"
        }
    }
    
    func imageName(selected: Bool) -> String {
        selected ? "\(rawValue)_fill" : rawValue
    }
    
    func colorName(selected: Bool) -> String {
        selected ? "mainColor" : "serve"
    }
}

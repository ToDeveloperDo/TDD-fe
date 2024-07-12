//
//  MainTabType.swift
//  TDD
//
//  Created by 최안용 on 7/11/24.
//

import Foundation

enum MainTabType: String, CaseIterable {
    case todo
    case calendar
    case myInfo
    
    var title: String {
        switch self {
        case .todo:
            return "몰라"
        case .calendar:
            return "캘린더"
        case .myInfo:
            return "내정보"        
        }
    }
    
    var systemImageName: String {
           switch self {
           case .todo:
               return "checkmark.circle"
           case .calendar:
               return "calendar"
           case .myInfo:
               return "person.circle"
           }
       }
}

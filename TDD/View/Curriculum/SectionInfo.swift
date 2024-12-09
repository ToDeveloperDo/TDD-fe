//
//  SectionInfo.swift
//  TDD
//
//  Created by 최안용 on 11/11/24.
//

import Foundation

enum SectionInfo: String, CaseIterable {
    case position
    case stack
    case period
    case level
    
    func kinds(for position: Position? = nil) -> [String] {
        switch self {
        case .position:
            return ["웹", "백엔드", "iOS", "안드로이드", "디자인"]
        case .stack:
            guard let position = position else { return [] }
            switch position {
            case .web:
                return ["React", "Vue", "Angular"]
            case .backend:
                return ["Node.js", "Spring", "Django"]
            case .iOS:
                return ["Swift", "Objective-C"]
            case .android:
                return ["Kotlin", "Java"]
            case .design:
                return ["Figma", "Sketch", "Adobe XD"]
            }
        case .period:
            return ["1개월", "2개월", "3개월", "4개월", "5개월", "6개월"]
        case .level:
            return ["하", "중", "상"]
        }
    }
}

enum Position: String {
    case web = "웹"
    case backend = "백엔드"
    case iOS = "iOS"
    case android = "안드로이드"
    case design = "디자인"
}

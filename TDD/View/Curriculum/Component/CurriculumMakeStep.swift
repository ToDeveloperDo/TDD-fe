//
//  CurriculumMakeStep.swift
//  TDD
//
//  Created by 최안용 on 12/14/24.
//

enum CurriculumMakeStep: String {
    case start
    case stack
    case position
    case period
    case level
    
    var title: String {
        switch self {
        case .start: ""
        case .stack: "어떤 기술을 배우고 싶으세요?"
        case .position: "어떤 분야에서 성장하고 싶으세요?"
        case .period: "얼마 동안 학습할 계획인가요?"
        case .level: "현재 레벨을 알려주세요!"
        }
    }
    
    var subTitle: String? {
        switch self {
        case .level: "선택한 수준에 따라 커리큘럼을 세밀하게 조정합니다"
        default: nil
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .level: "생성하기"
        default: "다음 단계"
        }
    }
    
    func kinds(position: String?) -> [String] {
        switch self {
        case .start: return []
        case .stack:
            guard let position = position else { return [] }
            
            if position == "웹" {
                return ["React", "Vue", "Angular"]
            } else if position == "백엔드" {
                return ["Node.js", "Spring", "Django"]
            } else if position == "iOS" {
                return ["Swift", "Objective-C"]
            } else if position == "안드로이드" {
                return ["Kotlin", "Java"]
            } else {
                return ["Figma", "Sketch", "Adobe XD"]
            }
        case .position:
            return ["웹", "백엔드", "iOS", "안드로이드", "디자인"]
        case .period:
            return ["1개월", "2개월", "3개월", "4개월", "5개월", "6개월"]
        case .level:
            return ["하", "중", "상"]
        }
    }
}

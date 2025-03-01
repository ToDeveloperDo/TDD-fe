//
//  NavigationDestination.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case userDetail(user: UserInfo, parent: NavigationRouterType)
    case fetchedCurriculum(curriculums: [Curriculum]?, id: Int?, selectedStep: [CurriculumMakeStep : String])
    case setting
    case teamIntroduction
    case personalInformation
    case createCurriculum
}

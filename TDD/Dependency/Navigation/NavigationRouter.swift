//
//  NavigationRouter.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Combine

protocol NavigationRoutable {
    var myProfileDestinations: [NavigationDestination] { get set }
    var questDestinations: [NavigationDestination] { get set }
    var curriculumDestinations: [NavigationDestination] { get set }
    func push(to view: NavigationDestination, on type: NavigationRouterType)
    func popAndPush(to view: NavigationDestination, on type: NavigationRouterType)
    func pop(on type: NavigationRouterType)
    func popToRootView(on type: NavigationRouterType)
}

enum NavigationRouterType {
    case myProfile
    case quest
    case curriculum
}

class NavigationRouter: NavigationRoutable, ObservableObjectSettable {
    
    var objectWillChange: ObservableObjectPublisher?
    
    var myProfileDestinations: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    var questDestinations: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    var curriculumDestinations: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func push(to view: NavigationDestination, on type: NavigationRouterType) {
        switch type {
        case .myProfile:
            myProfileDestinations.append(view)
        case .quest:
            questDestinations.append(view)
        case .curriculum:
            curriculumDestinations.append(view)
        }
    }
    
    func pop(on type: NavigationRouterType) {
        switch type {
        case .myProfile:
            _ = myProfileDestinations.popLast()
        case .quest:
            _ = questDestinations.popLast()
        case .curriculum:
            _ = curriculumDestinations.popLast()
        }
    }
    
    func popToRootView(on type: NavigationRouterType) {
        switch type {
        case .myProfile:
            myProfileDestinations = []
        case .quest:
            questDestinations = []
        case .curriculum:
            curriculumDestinations = []
        }
    }
    
    func popAndPush(to view: NavigationDestination, on type: NavigationRouterType) {
        switch type {
        case .myProfile:
            if !self.myProfileDestinations.isEmpty {
                _ = self.myProfileDestinations.popLast()
            }
            DispatchQueue.main.async {
                self.myProfileDestinations.append(view)
            }
        case .quest:
            if !self.questDestinations.isEmpty {
                _ = self.questDestinations.popLast()
            }
            DispatchQueue.main.async {
                self.questDestinations.append(view)
            }
        case .curriculum:
            if !self.curriculumDestinations.isEmpty {
                _ = self.curriculumDestinations.popLast()
            }
            DispatchQueue.main.async {
                self.curriculumDestinations.append(view) 
            }
        }
        
    }
}

//
//  NotificationCenter+Extension.swift
//  TDD
//
//  Created by 최안용 on 9/24/24.
//

import Foundation

extension Notification.Name {
    static let noRepository = Notification.Name("noRepository")
    static let expiredToken = Notification.Name("expiredToken")
    static let gitHubLogin = Notification.Name("gitHubLogin")
}

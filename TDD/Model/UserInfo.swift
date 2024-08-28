//
//  UserInfo.swift
//  TDD
//
//  Created by 최안용 on 8/10/24.
//

import Foundation

struct UserInfo: Identifiable, Hashable {
    let id = UUID().uuidString
    let userId: Int64
    let userName: String
    let profileUrl: String
    let gitUrl: String
    var status: InfoType
}

extension UserInfo {
    static let stu1: UserInfo = .init(userId: 1, userName: "Seogi", profileUrl: "", gitUrl: "https://github.com", status: .NOT_FRIEND)
    static let stu2: UserInfo = .init(userId: 1, userName: "Anyong", profileUrl: "", gitUrl: "https://github.com", status: .REQUEST)
    static let stu3: UserInfo = .init(userId: 1, userName: "Nana", profileUrl: "", gitUrl: "https://github.com", status: .FOLLOWING)
    static let stu4: UserInfo = .init(userId: 1, userName: "David", profileUrl: "", gitUrl: "https://github.com", status: .RECEIVE)
    static let stu5: UserInfo = .init(userId: 1, userName: "James", profileUrl: "", gitUrl: "https://github.com", status: .FOLLOWING)
    static let stu6: UserInfo = .init(userId: 1, userName: "Paka", profileUrl: "", gitUrl: "https://github.com", status: .NOT_FRIEND)
}

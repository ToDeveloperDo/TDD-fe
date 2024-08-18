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
    static let stu1: UserInfo = .init(userId: 1, userName: "최안용", profileUrl: "", gitUrl: "https://github.com/ChoiAnYong", status: .RECEIVE)
    static let stu2: UserInfo = .init(userId: 1, userName: "이준석", profileUrl: "", gitUrl: "https://github.com/ChoiAnYong", status: .NOT_FRIEND)
    static let stu3: UserInfo = .init(userId: 1, userName: "이광혁", profileUrl: "", gitUrl: "https://github.com/ChoiAnYong", status: .FOLLOWING)
    static let stu4: UserInfo = .init(userId: 1, userName: "김민욱", profileUrl: "", gitUrl: "https://github.com/ChoiAnYong", status: .REQUEST)
}

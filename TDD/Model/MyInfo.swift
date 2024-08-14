//
//  MyInfo.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation

struct MyInfo {
    let name: String
    let profileUrl: String
    let gitUrl: String
}

extension MyInfo {
    static let stub: MyInfo = .init(name: "최안용", profileUrl: "", gitUrl: "https://github.com/ChoiAnYong")
}

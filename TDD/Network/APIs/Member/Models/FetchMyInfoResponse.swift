//
//  FetchMyInfoResponse.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation

struct FetchMyInfoResponse: Decodable {
    let username: String
    let avatarUrl: String
    let gitUrl: String
}

extension FetchMyInfoResponse {
    func toModel() -> MyInfo {
        .init(name: username, profileUrl: avatarUrl, gitUrl: gitUrl)
    }
}

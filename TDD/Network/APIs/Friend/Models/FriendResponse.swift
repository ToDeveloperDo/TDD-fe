//
//  FriendResponse.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation

struct FriendResponse: Decodable {
    let memberId: Int64
    let username: String
    let avatarUrl: String
    let gitUrl: String
    let friendStatus: InfoType
}

extension FriendResponse {
    func toModel() -> UserInfo {
        .init(userId: memberId, userName: username, profileUrl: avatarUrl, gitUrl: gitUrl, status: friendStatus)
    }
}

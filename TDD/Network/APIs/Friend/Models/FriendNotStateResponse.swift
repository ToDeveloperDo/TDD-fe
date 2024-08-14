//
//  FriendNotStateResponse.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation

struct FriendNotStateResponse: Decodable {
    let memberId: Int64
    let friendUsername: String
    let friendGitUrl: String
    let avatarUrl: String
}

extension FriendNotStateResponse {
    func toFriendModel() -> UserInfo {
        .init(userId: memberId, userName: friendUsername, profileUrl: avatarUrl, gitUrl: friendGitUrl, status: .FOLLOWING)
    }
    
    func toSendModel() -> UserInfo {
        .init(userId: memberId, userName: friendUsername, profileUrl: avatarUrl, gitUrl: friendGitUrl, status: .REQUEST)
    }
    
    func toRecivetModel() -> UserInfo {
        .init(userId: memberId, userName: friendUsername, profileUrl: avatarUrl, gitUrl: friendGitUrl, status: .RECEIVE)
    }
}

//
//  FriendTarget.swift
//  TDD
//
//  Created by 최안용 on 8/13/24.
//

import Foundation
import Alamofire

enum FriendTarget {
    case searchFriend(SearchReqeust)
    case fetchFriendList
    case fetchFriend(Int64)
    case fetchSendList
    case fetchReceive
    case fetchFriendTodoList(Int64)
    case addFriend(Int64)
    case acceptFriend(Int64)
    case deleteFriend(Int64, DeleteRequest)
}

extension FriendTarget: TargetType {
    var baseURL: String {
        // 서비스
        return "https://api.todeveloperdo.shop"
        
        // 개발
//        return "https://dev.todeveloperdo.shop"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchFriend: return .post
        case .fetchFriendList: return .get
        case .fetchFriend: return .get
        case .fetchSendList: return .get
        case .fetchReceive: return .get
        case .fetchFriendTodoList: return .get
        case .addFriend: return .get
        case .acceptFriend: return .get
        case .deleteFriend: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .searchFriend: return "/api/member-friend/search"
        case .fetchFriendList: return "/api/member-friend"
        case .fetchFriend(let id): return "/api/member-friend/\(id)"
        case .fetchSendList: return "/api/member-friend/send-list"
        case .fetchReceive: return "/api/member-friend/request-list"
        case .fetchFriendTodoList(let id): return "/api/member-friend/lookup/todolist/\(id)"
        case .addFriend(let id): return "/api/member-friend/add/\(id)"
        case .acceptFriend(let id): return "/api/member-friend/accept/\(id)"
        case .deleteFriend(let id, _): return "/api/member-friend/\(id)"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .searchFriend(let request): return .body(request)
        case .fetchFriendList: return .empty
        case .fetchFriend: return .empty
        case .fetchSendList: return .empty
        case .fetchReceive: return .empty
        case .fetchFriendTodoList: return .empty
        case .addFriend: return .empty
        case .acceptFriend: return .empty
        case .deleteFriend(_, let request): return .query(request)
        }
    }
}

//
//  MemberAPI.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Combine
import Alamofire

final class MemberAPI {
    func fetchMyInfo() -> AnyPublisher<FetchMyInfoResponse, Error> {
        return API.session.request(MemberTarget.fetchMyInfo, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: FetchMyInfoResponse.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    func fetchAllMember() -> AnyPublisher<[FriendResponse], Error> {
        return API.session.request(MemberTarget.fetchAllMember, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [FriendResponse].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}

//
//  MemberService.swift
//  TDD
//
//  Created by 최안용 on 8/14/24.
//

import Foundation
import Combine

protocol MemberServiceType {
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError>
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError>
}

final class MemberService: MemberServiceType {
    private var memberAPI: MemberAPI
    
    init(memberAPI: MemberAPI) {
        self.memberAPI = memberAPI
    }
    
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError> {
        return memberAPI.fetchMyInfo()
            .map { $0.toModel() }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError> {
        return memberAPI.fetchAllMember()
            .map { $0.map { $0.toModel() } }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
}

final class StubMemberService: MemberServiceType {
    func fetchMyInfo() -> AnyPublisher<MyInfo, ServiceError> {
        Just(.stub)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchAllMember() -> AnyPublisher<[UserInfo], ServiceError> {
        Just([.stu1, .stu2, .stu3, .stu4])
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}

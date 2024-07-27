//
//  AuthAPI.swift
//  TDD
//
//  Created by 최안용 on 7/27/24.
//

import Foundation
import Combine
import Alamofire

final class AuthAPI {
    func signInWithApple(request: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return API.session.request(AuthAPITarget.signInWithApple(request))
            .publishDecodable(type: LoginResponse.self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}


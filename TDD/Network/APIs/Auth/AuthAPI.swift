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
    
    static func refreshToken(completion: @escaping (Bool) -> Void) {
        do {
            let refreshToken = try KeychainManager.shared.getData(.refresh)
            let request = RefreshRequest(refreshToken: refreshToken)
            
            API.session.request(AuthAPITarget.refreshToken(request))
                .response { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            guard let data = data else { return }
                            let result = try JSONDecoder().decode(RefreshResponse.self, from: data)
                            try KeychainManager.shared.create(.access, input: result.idToken)
                            completion(true)
                        } catch {
                            completion(false)
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            
        } catch {
            completion(false)
        }
    }
    
    func revokeWithApple() -> AnyPublisher<Void, Error> {
        return API.session.request(AuthAPITarget.revokeWithApple, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                return ()
            }
            .eraseToAnyPublisher()
    }
}


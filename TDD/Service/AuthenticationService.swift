//
//  AuthenticationService.swift
//  TDD
//
//  Created by 최안용 on 7/27/24.
//

import Foundation
import Combine
import AuthenticationServices

protocol AuthenticationServiceType {
    func signInWithAppleRequest(_ reqeust: ASAuthorizationAppleIDRequest) -> Void
    func signInwithAppleCompletion(_ authorization: ASAuthorization) -> AnyPublisher<(LoginResponse, String), ServiceError>
    func revokeWithApple() -> AnyPublisher<Void, ServiceError>
}

final class AuthenticationService: AuthenticationServiceType {
    func signInWithAppleRequest(_ reqeust: ASAuthorizationAppleIDRequest) -> Void {
        reqeust.requestedScopes = [.email, .fullName]
    }
    
    func signInwithAppleCompletion(_ authorization: ASAuthorization) -> AnyPublisher<(LoginResponse, String), ServiceError> {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let code = credential.authorizationCode else {
            return Fail(error: ServiceError.authorizationFailed).eraseToAnyPublisher()
        }
        
        guard let codeStr = String(data: code, encoding: .utf8) else {
            return Fail(error: ServiceError.authorizationFailed).eraseToAnyPublisher()
        }
        
        do {
            let clientToken = try KeychainManager.shared.getData(.clientToken)
            let request = LoginRequest(code: codeStr, clientToken: clientToken)
            return NetworkingManager.shared.requestNoAuth(AuthAPITarget.signInWithApple(request), type: LoginResponse.self)
                .map { return ($0, credential.user)}
                .mapError { error in
                    switch error {
                    case .notRepository:
                        return ServiceError.notRepository
                    case .serverError(let message):
                        return ServiceError.serverError(message)
                    case .error(let error):
                        return ServiceError.error(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: ServiceError.authorizationFailed).eraseToAnyPublisher()
        }
    }
    
    func revokeWithApple() -> AnyPublisher<Void, ServiceError> {
        return NetworkingManager.shared.requestWithAuth(AuthAPITarget.revokeWithApple, type: EmptyResponse.self)
            .map { _ in () }
            .mapError { error in
                switch error {
                case .notRepository:
                    return ServiceError.notRepository
                case .serverError(let message):
                    return ServiceError.serverError(message)
                case .error(let error):
                    return ServiceError.error(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

final class StubAuthenticationService: AuthenticationServiceType {
    func signInWithAppleRequest(_ reqeust: ASAuthorizationAppleIDRequest) {
        
    }
    
    func signInwithAppleCompletion(_ authorization: ASAuthorization) -> AnyPublisher<(LoginResponse, String), ServiceError> {
        Just((LoginResponse(idToken: "성공", refreshToken: "성공"), "id"))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func revokeWithApple() -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}

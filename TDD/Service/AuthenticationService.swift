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
    private var authAPI: AuthAPI
    
    init(authAPI: AuthAPI) {
        self.authAPI = authAPI
    }
    
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
        
        let request = LoginRequest(code: codeStr)
        return authAPI.signInWithApple(request: request)
            .map { return ($0, credential.user) }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func revokeWithApple() -> AnyPublisher<Void, ServiceError> {
        return authAPI.revokeWithApple()
            .mapError { ServiceError.error($0) }
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

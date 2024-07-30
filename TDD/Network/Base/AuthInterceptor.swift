//
//  AuthInterceptor.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    static var shared = AuthInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        do {
            let accessToken = try KeychainManager.shared.getData(.access)
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            completion(.success(urlRequest))
        } catch {
            completion(.failure(KeychainError.notFound))
        }
    }
}

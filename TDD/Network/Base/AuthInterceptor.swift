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
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        AuthAPI.refreshToken { succeed in
            if succeed {
                completion(.retry)
            } else {
                
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

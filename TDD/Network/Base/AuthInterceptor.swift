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
        
        AuthInterceptor.refreshToken { succeed in
            if succeed {
                completion(.retry)
            } else {
                // 로그인
                NotificationCenter.default.post(name: .expiredToken, object: nil)
                completion(.doNotRetryWithError(error))
            }
        }
    }
}

extension AuthInterceptor {
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

}

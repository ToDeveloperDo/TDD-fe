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
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDaG9pQW5Zb25nIiwiaXNzIjoiTWVhbE1hdGUiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNzIyMTQ1ODg3fQ.MtGBPQfpM6sEzntltGgSByEm5fYKtJX-DTVE9Ptfca4wo_Dg4eR1MEO2GThhJDxfqvCP3NH1mhAIh2uPFGM6dA"
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}

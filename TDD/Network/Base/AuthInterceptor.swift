//
//  AuthInterceptor.swift
//  TDD
//
//  Created by 최안용 on 7/17/24.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDaG9pQW5Zb25nIiwiaXNzIjoiTWVhbE1hdGUiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNzIxMjg5ODk3fQ.LJWR9H0XiUpFwLDjg0NU0cXUbc5KBvZZnYoPgVIIrTs71nqNgZMvY5ZJp7YMSYb_N7cDf_3d3DmtBwGt6tZVEA"
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
}

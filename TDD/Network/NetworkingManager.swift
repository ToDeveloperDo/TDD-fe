//
//  NetworkingManager.swift
//  TDD
//
//  Created by 최안용 on 9/23/24.
//

import Foundation
import Combine
import Alamofire

final class NetworkingManager {
    static let shared = NetworkingManager()
    
    func requestWithAuth<T: Decodable>(_ endpoint: TargetType, type: T.Type) -> AnyPublisher<T, NetworkError> {
        return API.session.request(endpoint, interceptor: AuthInterceptor.shared)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .tryMap { response in
                if let httpResponse = response.response {
                    switch httpResponse.statusCode {
                    case 400:
                        if let data = response.data {
                            let decodedError = try? JSONDecoder().decode(ServerErrorResponse.self, from: data)
                            let errorMessage = decodedError?.message ?? "Unknown Error"
                            throw NetworkError.serverError(errorMessage)
                        } else {
                            throw NetworkError.serverError("Unknown Error")
                                            }
                    case 404:
                        throw NetworkError.notRepository
                    default:
                        break
                    }
                }
                guard let value = response.value else {
                    throw NetworkError.serverError("Invalid response data")
                }
                return value
            }
            .mapError { error in
                return error as? NetworkError ?? NetworkError.error(error)
            }
            .eraseToAnyPublisher()
    }
    
    func requestNoAuth<T: Decodable>(_ endpoint: TargetType, type: T.Type) -> AnyPublisher<T, NetworkError> {
        return API.session.request(endpoint)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .tryMap { response in
                if let httpResponse = response.response {
                    switch httpResponse.statusCode {
                    case 400:
                        if let data = response.data,
                           let errorMessage = String(data: data, encoding: .utf8) {
                            throw NetworkError.serverError(errorMessage)
                        } else {
                            throw NetworkError.serverError("Unknown Error")
                        }
                    case 404:
                        throw NetworkError.notRepository
                    default:
                        break
                    }
                }
                guard let value = response.value else {
                    throw NetworkError.serverError("Invalid response data")
                }
                return value
            }
            .mapError { error in
                return error as? NetworkError ?? NetworkError.error(error)
            }
            .eraseToAnyPublisher()
    }
}

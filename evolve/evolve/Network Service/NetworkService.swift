//
//  NetworkService.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func perform<T: Decodable>(endPoint: EndPointProvider,
                               parsingKey: String?) -> AnyPublisher<T, Error>
}

struct NetworkService {
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension NetworkService: NetworkServiceProtocol {
    func perform<T: Decodable>(endPoint: EndPointProvider,
                               parsingKey: String?) -> AnyPublisher<T, Error> {
        do {
            return session
                .dataTaskPublisher(for: try endPoint.buildRequest())
                .tryMap { output in
                    try self.manageResponse(output.response,
                                            data: output.data,
                                            parsingKey: parsingKey)
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(outputType: T.self, failure: error)
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Private Methods
private extension NetworkService {
    func manageResponse<T: Decodable>(_ response: URLResponse?, data: Data?,
                                      parsingKey: String? = nil) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        guard let data = data else {
            throw NetworkError.noData
        }

        switch response.statusCode {
        case 200...299:
            return try DecodingHelper.decode(from: data, for: parsingKey)

        default:
            throw NetworkError.unknownError
        }
    }
}

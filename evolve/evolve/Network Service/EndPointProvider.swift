//
//  EndPointProvider.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Foundation

protocol EndPointProvider {
    var baseURL: String { get }
    var path: String { get }
    var task: HTTPTask { get }
    var urlScheme: URLScheme { get }
    var headers: HTTPHeaders { get }
    var httpMethod: HTTPMethod { get }
    var fetchFromLocalHost: Bool { get }
}

extension EndPointProvider {
    var baseURL: String {
        ""
    }

    var task: HTTPTask {
        .request
    }

    var urlScheme: URLScheme {
        .https
    }

    var headers: HTTPHeaders {
        [:]
    }

    var httpMethod: HTTPMethod {
        .get
    }

    var fetchFromLocalHost: Bool {
        false
    }
}

extension EndPointProvider {
    func buildRequest() throws -> URLRequest {
        var components = URLComponents()
        components.path = baseURL + path
        components.scheme = urlScheme.rawValue

        if fetchFromLocalHost {
            components.host = "localhost"
            components.port = 8000
        }
        
        guard let url = components.url else {
            throw NetworkError.missingURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if !headers.isEmpty {
            request.allHTTPHeaderFields = headers
        }
        
        switch task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        case .requestParameters(let bodyParameters,
                                let urlParameters,
                                let additionalHeaders):
            addAdditionalHeaders(additionalHeaders, request: &request)
            try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
        }

        return request
    }
}

// MARK: - Private Methods
private extension EndPointProvider {
    func addAdditionalHeaders(_ headers: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = headers, !headers.isEmpty else {
            return
        }
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func configureParameters(bodyParameters: Parameters?,
                             urlParameters: Parameters?, request: inout URLRequest) throws {
        guard let url = request.url else {
            throw NetworkError.missingURL
        }

        if let urlParameters, !urlParameters.isEmpty,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.queryItems = urlParameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            request.url = components.url
        }
        
        if let bodyParameters, !bodyParameters.isEmpty {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }
    }
}

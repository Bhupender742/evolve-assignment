//
//  ExploreEndPointProvider.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Foundation

enum ExploreEndPointPointProvider {
    case fetchFilters
    case fetchItems(params: Parameters)
}

extension ExploreEndPointPointProvider: EndPointProvider {
    var urlScheme: URLScheme {
        .http
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetchFilters:
            return .get
            
        case .fetchItems:
            return .post
        }
    }

    var path: String {
        switch self {
        case .fetchFilters:
            return "/filters"
        
        case .fetchItems:
            return "/items"
        }
    }

    var task: HTTPTask {
        switch self {
        case .fetchFilters:
            return .request

        case .fetchItems(let params):
            return .requestParameters(bodyParameters: params,
                                      urlParameters: nil,
                                      additionalHeaders: nil)
        }
    }

    var fetchFromLocalHost: Bool {
        true
    }
}

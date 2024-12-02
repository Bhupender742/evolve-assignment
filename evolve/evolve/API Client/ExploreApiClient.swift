//
//  ExploreApiClient.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Combine
import Foundation

protocol ExploreApiClientProtocol {
    func fetchFilters() -> AnyPublisher<[Filter], Error>
    func fetchItems(page: Int, keyword: String, filters: String) -> AnyPublisher<[ExploreItem], Error>
}

struct ExploreApiClient: ExploreApiClientProtocol {
    private var networkService: NetworkServiceProtocol = NetworkService()

    func fetchFilters() -> AnyPublisher<[Filter], Error> {
        networkService.perform(endPoint: ExploreEndPointPointProvider.fetchFilters, parsingKey: "filters")
    }

    func fetchItems(page: Int, keyword: String, filters: String) -> AnyPublisher<[ExploreItem], Error> {
        var params = Parameters()
        params["page"] = page
        params["keyword"] = keyword
        if !filters.isEmpty {
            params["filters"] = filters
        }
        return networkService.perform(endPoint: ExploreEndPointPointProvider.fetchItems(params: params), parsingKey: "items")
    }
}

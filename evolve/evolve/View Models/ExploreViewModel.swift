//
//  ExploreViewModel.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Combine
import SwiftData
import Foundation

enum ViewState {
    case loading
    case loaded
}

@Observable
class ExploreViewModel {
    @ObservationIgnored let apiClient: ExploreApiClientProtocol
    var items = [ExploreItem]()
    private(set) var filters = [Filter]()
    // View States
    var viewState: ViewState = .loaded
    var errorViewState: ViewState = .loaded
    var collectionViewState: ViewState = .loaded
    // Non Observables
    @ObservationIgnored var searchText: String = ""
    @ObservationIgnored private var currentPage = 0
    @ObservationIgnored private(set) var canLoadMore: Bool = true
    private var modelContext: ModelContext
    private(set) var networkMonitor: NetworkMonitor
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    // Errors
    private(set) var fetchItemsError: Error?
    private(set) var fetchFiltersError: Error?

    init(apiClient: ExploreApiClientProtocol = ExploreApiClient(),
         modelContext: ModelContext, networkMonitor: NetworkMonitor) {
        self.apiClient = apiClient
        self.modelContext = modelContext
        self.networkMonitor = networkMonitor
    }
}

// MARK: - Helper
extension ExploreViewModel {
    func fetchInitialData() {
        resetPage()
        fetchFilters()
        fetchItems(resetPage: true)
    }

    func fetchItems(resetPage: Bool = false) {
        guard networkMonitor.isConnected else {
            loadSavedItems()
            return
        }

        if resetPage {
            self.resetPage()
            viewState = .loading
        }

        apiClient.fetchItems(page: currentPage,
                             keyword: searchText,
                             filters: filterString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    self.fetchItemsError = nil
                case .failure(let failure):
                    self.fetchItemsError = failure
                }

                if resetPage {
                    self.delayLoader()
                }

                self.errorViewState = .loaded
            }, receiveValue: { [weak self] items in
                guard let self else { return }
                self.collectionViewState = .loaded

                // No more items to load
                if items.isEmpty {
                    canLoadMore = false
                    return
                }
                
                if resetPage {
                    self.items = items
                } else {
                    self.items.append(contentsOf: items)
                }

                self.currentPage += 1
                saveItems()
            })
            .store(in: &cancellables)
    }
    
    func performSearch(for query: String) {
        guard networkMonitor.isConnected else {
            loadSavedItems()
            return
        }

        resetPage()
        viewState = .loading
        apiClient.fetchItems(page: currentPage,
                             keyword: query,
                             filters: filterString)
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    self.fetchItemsError = nil
                case .failure(let failure):
                    self.fetchItemsError = failure
                }
                self.viewState = .loaded
            }, receiveValue: { [weak self] items in
                guard let self else { return }
                self.items = items
            })
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension ExploreViewModel {
    var filterString: String {
        filters.filter({ $0.isSelected }).map { $0.title }.joined(separator: ",")
    }

    func resetPage() {
        currentPage = 0
        canLoadMore = true
    }

    func fetchFilters() {
        guard networkMonitor.isConnected else {
            loadSavedFilters()
            return
        }
        
        viewState = .loading
        apiClient.fetchFilters()
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    self.fetchFiltersError = nil
                case .failure(let failure):
                    self.fetchFiltersError = failure
                }
                self.errorViewState = .loaded
            }, receiveValue: { [weak self] filters in
                guard let self else { return }
                self.filters = filters.compactMap({ filter in
                    guard !filter.title.isEmpty else { return nil }
                    return filter
                }).sorted(by: { $0.id < $1.id })
                saveFilters()
            })
            .store(in: &cancellables)
    }

    func saveFilters() {
        _ = try? modelContext.delete(model: Filter.self)
        filters.forEach { filter in
            modelContext.insert(filter)
        }
    }

    func saveItems() {
        guard searchText.isEmpty,
              filterString.isEmpty else { return }
        _ = try? modelContext.delete(model: ExploreItem.self)
        items.forEach { item in
            modelContext.insert(item)
        }
    }

    func loadSavedFilters() {
        let filterDescriptor = FetchDescriptor<Filter>(sortBy: [SortDescriptor(\.id)])
        filters = (try? modelContext.fetch(filterDescriptor)) ?? []
    }

    func loadSavedItems() {
        let itemDescriptor = FetchDescriptor<ExploreItem>(sortBy: [SortDescriptor(\.id)])
        var savedItems = (try? modelContext.fetch(itemDescriptor)) ?? []

        if !searchText.isEmpty {
            savedItems = savedItems.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }

        let selectedFilters = filters.filter({ $0.isSelected }).map { $0.title }
        let selectedFiltersSet = Set(selectedFilters)

        savedItems = savedItems.filter { item in
            guard let problems = item.problems, !problems.isEmpty else {
                return false
            }
            let applicableFiltersSet = Set(problems)
            return selectedFiltersSet.isSubset(of: applicableFiltersSet)
        }

        items = savedItems
    }

    func delayLoader() {
        Just("Delay Loader")
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.viewState = .loaded
            })
            .store(in: &cancellables)
    }
}

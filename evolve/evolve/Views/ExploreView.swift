//
//  ExploreView.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI
import SwiftData

struct ExploreView: View {
    @State var viewModel: ExploreViewModel
    @StateObject var debounceObject = DebounceObject()

    init(modelContext: ModelContext, networkMonitor: NetworkMonitor) {
        let viewModel = ExploreViewModel(modelContext: modelContext,
                                         networkMonitor: networkMonitor)
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !viewModel.networkMonitor.isConnected {
                renderOfflineView
            }

            HeaderView(title: LocalizationKeys.Explore.explore.captialized)
                .padding()
            
            Text(LocalizationKeys.Explore.discover.captialized)
                .font(.system(size: 26))
                .padding()
            
            SearchBar(text: $debounceObject.text)
                .onChange(of: debounceObject.debouncedText) {
                    viewModel.searchText = debounceObject.debouncedText
                    viewModel.performSearch(for: debounceObject.debouncedText)
                }

            FiltersView(filters: viewModel.filters)
                .padding()
                .padding([.top], -16)
                .frame(height: 64)
                .environment(viewModel)

            if viewModel.viewState == .loading {
                ContentUnavailableView {
                    ProgressView()
                }
            } else if viewModel.items.isEmpty {
                ContentUnavailableView {
                    Label(LocalizationKeys.Error.noResultsFound.value, systemImage: "tray")
                } actions: {
                    Button {
                        viewModel.searchText = ""
                        viewModel.fetchInitialData()
                    } label: {
                        Text(LocalizationKeys.Explore.reset.captialized)
                            .font(.callout)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 96, height: 48)
                    .background(.blue)
                    .clipShape(Capsule())
                }
            } else {
                ExploreCollectionView(items: $viewModel.items,
                                      viewState: $viewModel.collectionViewState)
                    .padding()
                    .scrollDismissesKeyboard(.immediately)
                    .onScrollTargetVisibilityChange(idType: ExploreItem.ID.self, threshold: 0.3) { itemId in
                        if let lastItem = viewModel.items.last,
                           itemId.contains(where: { $0 == lastItem.id }), viewModel.canLoadMore {
                            viewModel.fetchItems()
                        }
                    }
            }
        }
        .overlay {
            if viewModel.fetchFiltersError != nil || viewModel.fetchItemsError != nil {
                renderErrorView
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.fetchInitialData()
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Private
private extension ExploreView {
    var renderOfflineView: some View {
        HStack {
            Image(systemName: "network.slash")
                .resizable()
                .frame(width: 32, height: 32)

            Text(LocalizationKeys.Error.youAreOffline.value)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.red)
    }

    var renderErrorView: some View {
        ZStack {
            Color.black
            if let error = viewModel.fetchFiltersError {
                ErrorView(text: error.localizedDescription,
                          viewState: $viewModel.errorViewState) {
                    viewModel.fetchInitialData()
                }
            } else if let error = viewModel.fetchItemsError {
                ErrorView(text: error.localizedDescription,
                          viewState: $viewModel.errorViewState) {
                    viewModel.fetchItems(resetPage: true)
                }
            }
        }
    }
}

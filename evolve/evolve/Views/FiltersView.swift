//
//  FiltersView.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI

struct FiltersView: View {
    var filters: [Filter]
    private let gridItems = [GridItem()]
    @Environment(ExploreViewModel.self) var viewModel

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: gridItems, spacing: 8) {
                ForEach(filters) { filter in
                    @Bindable var filter = filter

                    HStack(spacing: 8) {
                        Text("\(filter.title)")
                            .font(.caption)
                            .foregroundStyle(.white)
                        
                        if filter.isSelected {
                            Image(systemName: "checkmark")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.primary)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding([.top, .bottom], 8)
                    .padding([.leading, .trailing], 16)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                    .preferredColorScheme(.dark)
                    .onTapGesture {
                        filter.isSelected = !filter.isSelected
                        viewModel.fetchItems(resetPage: true)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FiltersView(filters: [])
}

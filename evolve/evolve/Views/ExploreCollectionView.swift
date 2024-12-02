//
//  ExploreCollectionView.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI

struct ExploreCollectionView: View {
    @Binding var items: [ExploreItem]
    @Binding var viewState: ViewState
    private let gridItems = [GridItem(spacing: 24), GridItem()]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach($items.wrappedValue) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        if let data = item.imageData,
                           let image = UIImage(data: data) {
                            renderImageView(with: image, for: item)
                        } else {
                            renderCacheImageView(for: item)
                        }

                        Text("\(item.title ?? "")")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(height: 52, alignment: .leading)
                        
                        HStack {
                            Text("\(item.sessions ?? "")")
                            Text("\u{2022}")
                            Text("\(item.descriptionTitle ?? "")")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .padding([.top, .bottom], 4)
                    }
                }

                if viewState == .loading {
                    ProgressView()
                }
            }
        }
        .scrollTargetLayout()
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .alwaysByFew))
        .scrollBounceBehavior(.basedOnSize)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Private
private extension ExploreCollectionView {
    func renderImageView(with image: UIImage, for item: ExploreItem) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                if item.isPremium {
                    LockedView()
                }
            }
    }

    func renderCacheImageView(for item: ExploreItem) -> some View {
        CacheAsyncImage(
            url: URL(string: item.image ?? ""),
            transaction: .init(animation: .easeIn(duration: 3))
        ) { phase in
            switch phase {
            case .success(let image):
                ExploreImageView(image: image, item: item)
                    .overlay {
                        if item.isPremium {
                            LockedView()
                        }
                    }
                
            case .failure:
                ContentUnavailableView {
                    Text(LocalizationKeys.Image.noImage.value)
                        .font(.subheadline)
                }
                .overlay {
                    if item.isPremium {
                        LockedView()
                    }
                }
                
            default:
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

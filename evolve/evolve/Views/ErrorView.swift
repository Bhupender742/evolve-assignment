//
//  ErrorView.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI

struct ErrorView: View {
    var text: String
    @Binding var viewState: ViewState
    var retryHandler: (() -> Void)

    var body: some View {
        VStack {
            if viewState == .loading {
                VStack {
                    ProgressView()

                    Text(LocalizationKeys.Explore.loading.captialized)
                        .font(.title)
                }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 64, height: 64)
                
                Text(text)
                    .font(.title3)
                
                Button {
                    retryHandler()
                    viewState = .loaded
                } label: {
                    Text(LocalizationKeys.Explore.retry.captialized)
                        .font(.callout)
                        .foregroundStyle(.white)
                }
                .frame(width: 96, height: 48)
                .background(.blue)
                .clipShape(Capsule())
            }
        }
        .animation(.easeIn(duration: 1))
    }
}

//
//  HeaderView.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI

struct HeaderView: View {
    var title: String
    @State var isLiked: Bool = false
    @State var listeningToMusic: Bool = false
    @State private var animationAmount: CGFloat = 1

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 32))
                .foregroundStyle(.primary)
            
            Spacer()

            Button {
                isLiked.toggle()
            } label: {
                Image("fav_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(isLiked ? .red: .primary)
                    .frame(width: 38, height: 38)
            }
            .buttonStyle(ScaleButtonStyle())

            Button {
                listeningToMusic.toggle()
            } label: {
                Image("music_icon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(listeningToMusic ? .green: .primary)
                    .frame(width: 38, height: 38)
            }
            .overlay {
                if listeningToMusic {
                    Circle()
                        .stroke(listeningToMusic ? .green: .clear)
                        .scaleEffect(animationAmount)
                        .opacity(2 - animationAmount)
                        .animation(
                            .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                }
            }
            .onChange(of: listeningToMusic) {
                animationAmount = listeningToMusic ? 2: 1
            }
        }
    }
}

#Preview {
    HeaderView(title: "Explore")
}

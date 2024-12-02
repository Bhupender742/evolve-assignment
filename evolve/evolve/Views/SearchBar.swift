//
//  SearchBar.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
        
    var body: some View {
        HStack {
            TextField(LocalizationKeys.Explore.search.captialized, text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}


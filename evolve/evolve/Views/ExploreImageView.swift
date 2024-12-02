//
//  ExploreImageView.swift
//  evolve
//
//  Created by Lucifer on 01/12/24.
//

import SwiftUI

struct ExploreImageView: View {
    let image: Image
    var item: ExploreItem

    var body: some View {
        image
            .resizable()
    }
    
    init(image: Image, item: ExploreItem) {
        self.image = image
        self.item = item
        item.imageData = ImageRenderer(content: image).uiImage?.pngData()
    }
}

//
//  ScaleButtonStyle.swift
//  evolve
//
//  Created by Lucifer on 01/12/24.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 2: 1)
            .animation(.bouncy, value: configuration.isPressed)
    }
}

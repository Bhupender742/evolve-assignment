//
//  evolveApp.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftUI
import SwiftData

@main
struct evolveApp: App {
    let container: ModelContainer
    @State var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ExploreView(modelContext: container.mainContext,
                        networkMonitor: networkMonitor)
        }
        .modelContainer(container)
    }

    init() {
        do {
            container = try ModelContainer(for: Filter.self, ExploreItem.self)
        } catch {
            fatalError("Failed to create ModelContainer.")
        }
    }
}

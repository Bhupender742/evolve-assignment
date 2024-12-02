//
//  NetworkMonitor.swift
//  evolve
//
//  Created by Lucifer on 01/12/24.
//

import Network
import Foundation

@Observable
final class NetworkMonitor {
    @ObservationIgnored private let networkMonitor = NWPathMonitor()
    @ObservationIgnored private let workerQueue = DispatchQueue(label: "Monitor")
    private(set) var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}

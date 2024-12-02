//
//  DebouncedObject.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Combine
import Foundation

final class DebounceObject: ObservableObject {
    @Published var text: String = ""
    @Published var debouncedText: String = ""
    private var cancellables = Set<AnyCancellable>()

    public init(dueTime: TimeInterval = 1) {
        $text
            .removeDuplicates()
            .debounce(for: .seconds(dueTime), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.debouncedText = value
            })
            .store(in: &cancellables)
    }
}

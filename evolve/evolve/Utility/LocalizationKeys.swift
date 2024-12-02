//
//  LocalizationKeys.swift
//  evolve
//
//  Created by Lucifer on 01/12/24.
//

import Foundation

protocol Localizable {
    var value: String { get }
    var captialized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var value: String {
        return NSLocalizedString(rawValue, comment: "")
    }

    var captialized: String {
        return NSLocalizedString(rawValue, comment: "").capitalized
    }
}

struct LocalizationKeys {
    enum Image: String, Localizable {
        case noImage = "No Image"
    }

    enum Explore: String, Localizable {
        case explore
        case discover
        case reset
        case retry
        case search
        case loading
    }

    enum Error: String, Localizable {
        case youAreOffline = "You are Offline"
        case noResultsFound = "No Results Found"
    }
}

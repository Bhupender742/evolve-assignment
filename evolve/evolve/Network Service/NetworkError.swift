//
//  NetworkError.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Foundation

enum NetworkError: Error {
    case missingURL
    case noResponse
    case noData
    case unknownError
}

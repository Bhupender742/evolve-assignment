//
//  Filter.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftData
import Foundation

@Model
final class Filter: Decodable, Identifiable {
    var id: Int
    var title: String
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, title, isSelected
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }

    init(id: Int, title: String, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}

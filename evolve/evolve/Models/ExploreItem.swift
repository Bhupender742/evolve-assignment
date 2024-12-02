//
//  ExploreItem.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import SwiftData
import Foundation

@Model
final class ExploreItem: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var image: String?
    private var premium: String?
    var sessions: String?
    var descriptionTitle: String?
    var problems: [String]?
    var imageData: Data?

    var isPremium: Bool {
        return premium?.lowercased() == "premium"
    }

    enum CodingKeys: String, CodingKey {
        case id, title, sessions, problems
        case descriptionTitle = "description"
        case image = "thumb_image"
        case premium = "ju_premium"
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.title = try? container.decode(String.self, forKey: .title)
        self.image = try? container.decode(String.self, forKey: .image)
        self.premium = try? container.decode(String.self, forKey: .premium)
        self.descriptionTitle = try? container.decode(String.self, forKey: .descriptionTitle)
        self.sessions = try? container.decode(String.self, forKey: .sessions)
        self.problems = try? container.decodeIfPresent([String].self, forKey: .problems)
    }

    init(id: Int?, title: String?, image: String?,
         premium: String?, sessions: String?, description: String?) {
        self.id = id
        self.title = title
        self.image = image
        self.premium = premium
        self.sessions = sessions
        self.descriptionTitle = description
    }
}

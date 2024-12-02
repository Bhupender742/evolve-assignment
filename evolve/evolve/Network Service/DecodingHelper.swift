//
//  DecodingHelper.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Foundation

struct DecodingHelper {
    static let modelKey = "my_model_key"
    
    private struct Key: CodingKey {
        var intValue: Int?
        var stringValue: String
        
        init?(intValue: Int) {
            return nil
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
    }

    private struct ModelResponse<NestedModel: Decodable>: Decodable {
        let nested: NestedModel
        
        init(from decoder: Decoder) throws {
            var keyPaths = (decoder.userInfo[CodingUserInfoKey(rawValue: modelKey)!] as! String).split(separator: ".")
            let lastKey = String(keyPaths.popLast()!)
            
            var targetContainer = try decoder.container(keyedBy: Key.self)
            for k in keyPaths {
                let key = Key(stringValue: String(k))
                targetContainer = try targetContainer.nestedContainer(keyedBy: Key.self, forKey: key!)
            }
            
            nested = try targetContainer.decode(NestedModel.self, forKey: Key(stringValue: lastKey)!)
        }
    }
}

extension DecodingHelper {
    static func decode<T: Decodable>(from data: Data, for key: String? = nil) throws -> T {
        let decoder = JSONDecoder()

        guard let unwrappedKey = key else {
            return try decoder.decode(T.self, from: data)
        }
        
        decoder.userInfo[CodingUserInfoKey(rawValue: modelKey)!] = unwrappedKey
        return try decoder.decode(ModelResponse<T>.self, from: data).nested
    }
}

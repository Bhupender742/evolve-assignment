//
//  URLEncodeer.swift
//  evolve
//
//  Created by Lucifer on 30/11/24.
//

import Foundation

struct URLEncoder {
    static let URLQueryAllowed: CharacterSet = {
        let kAFCharactersGeneralDelimitersToEncode: String = "#[]@"
                let kAFCharactersSubDelimitersToEncode: String = "!$&'()*+,;="
                let allowedCharacterSet: NSMutableCharacterSet = ((CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy()
                    as? NSMutableCharacterSet)!
                allowedCharacterSet.removeCharacters(in: kAFCharactersGeneralDelimitersToEncode + kAFCharactersSubDelimitersToEncode)
        return allowedCharacterSet as CharacterSet
//
//        let generalDelimitersToEncode = "#[]@"
//        let subDelimitersToEncode = "!$&'()*+,;="
//        let encodableDelimiters = CharacterSet(
//            charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
//        return CharacterSet.urlHostAllowed.subtracting(encodableDelimiters)
    }()
}

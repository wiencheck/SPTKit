//
//  File.swift
//  
//
//  Created by Adam Wienconek on 09/11/2022.
//

import Foundation

struct Nested<T>: Decodable where T: Nestable {
    
    let items: [T]

    private struct CodingKeys: CodingKey {
        let stringValue: String
        let intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) { fatalError() }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codingKey = CodingKeys(stringValue: T.pluralKey)!
        let throwables = try container.decode([Throwable<T>].self, forKey: codingKey)
        items = throwables.compactMap {
            do {
                return try $0.result.get()
            } catch {
                print(error)
            }
            return nil
        }
    }
}


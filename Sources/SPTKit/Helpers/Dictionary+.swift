//
//  File.swift
//  
//
//  Created by Adam Wienconek on 23/10/2020.
//

import Foundation

extension Dictionary {
    mutating func updateValue(_ value: Value?, forKey key: Key) {
        if self[key] == nil && value == nil {
            return
        }
        self[key] = value
    }
}

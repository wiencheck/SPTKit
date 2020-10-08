//
//  File.swift
//  
//
//  Created by Adam Wienconek on 08/10/2020.
//

import Foundation

final class SPTJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}

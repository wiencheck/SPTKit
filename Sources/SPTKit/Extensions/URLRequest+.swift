//
//  File.swift
//  
//
//  Created by Adam Wienconek on 30/11/2020.
//

import Foundation

extension URLRequest {
    
    init(url: URL, method: HTTPMethod, headers: [String: String] = [:]) {
        self.init(url: url)
        self.httpMethod = method.rawValue
        headers.forEach { key, value in
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

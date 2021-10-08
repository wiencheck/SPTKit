//
//  File.swift
//  
//
//  Created by Adam Wienconek on 18/01/2021.
//

import Foundation

public struct SPTDevice: Codable {
    public let id: String
    
    public let isActive: Bool
    
    public let isPrivateSession: Bool
    
    public let isRestricted: Bool
    
    public let name: String
    
    public let type: String
    
    public let volumePercent: Int
    
    // - MARK: Coding keys
    private enum CodingKeys: String, CodingKey {
        case id, name, type
        case isActive = "is_active"
        case isPrivateSession = "is_private_session"
        case isRestricted = "is_restricted"
        case volumePercent = "volume_percent"
    }
}

extension SPTDevice: Nestable {
    public static var pluralKey: String {
        return "devices"
    }
}

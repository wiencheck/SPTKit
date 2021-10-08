//
//  File.swift
//  
//
//  Created by Adam Wienconek on 18/01/2021.
//

import Foundation

public class SPTPlayback: Codable {
    public let context: Context
    
    public let timestamp: Int
    
    public let progressMs: Int
    
    public let isPlaying: Bool
    
    public let currentlyPlayingType: SPTObjectType
    
    public let item: SPTTrack
    
    // - MARK: Coding keys
    private enum CodingKeys: String, CodingKey {
        case context, timestamp, item
        case progressMs = "progress_ms"
        case isPlaying = "is_playing"
        case currentlyPlayingType = "currently_playing_type"
    }
}

public extension SPTPlayback {
    struct Context: Codable {
        let externalUrls: [URL]
        
        let url: URL
        
        let type: String
        
        let uri: String
        
        // - MARK: Coding keys
        private enum CodingKeys: String, CodingKey {
            case externalUrls = "external_urls"
            case url = "href"
            case type, uri
        }
    }
}

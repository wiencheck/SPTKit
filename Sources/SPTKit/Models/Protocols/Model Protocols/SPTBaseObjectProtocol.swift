//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTBaseObjectProtocol: Decodable, Hashable, CustomStringConvertible {
    /**
     The object type.
     */
    var type: SPTObjectType { get }
    
    /**
     The Spotify URI for the object.
     */
    var uri: String { get }
    
    /**
     The Spotify ID for the object.
     */
    var id: String { get }
    
    /**
     A link to the Web API endpoint providing full details of the object.
     */
    var url: URL { get }
    
    /**
     Known external URLs for this object.
     */
    var externalURLs: [String: URL] { get }
}

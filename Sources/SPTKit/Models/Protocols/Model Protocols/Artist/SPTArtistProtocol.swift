//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation
public protocol SPTArtistProtocol: SPTBaseObjectProtocol, Nestable {
    /**
     The name of this artist.
     */
    var name: String { get }
    
    /**
     Information about the followers of the artist.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var followers: SPTFollowers? { get }
    
    /**
     A list of the genres the artist is associated with. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var genres: [String]? { get }
    
    /**
     Images of the artist in various sizes, widest first.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var images: [SPTImage]? { get }
    
    /**
     The popularity of the artist. The value will be between 0 and 100, with 100 being the most popular. The artist’s popularity is calculated from the popularity of all the artist’s tracks.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var popularity: Int? { get }
}

public extension SPTArtistProtocol where Self: Nestable {
    static var pluralKey: String {
        return "artists"
    }
}

//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation
public protocol SPTAlbumProtocol: SPTBaseObjectProtocol, Nestable {
    /**
     The name of this album.
     */
    var name: String { get }
    
    /**
     The field is present when getting an artist’s albums. Possible values are “album”, “single”, “compilation”, “appears_on”. Compare to album_type this field represents relationship between the artist and the album.
     */
    var albumGroup: AlbumGroup? { get }
    
    /**
     The type of the album: one of “album”, “single”, or “compilation”.
     */
    var albumType: AlbumType { get }
    
    /**
     The artists of the album. Each artist object includes a link in href to more detailed information about the artist.
     */
    var artists: [SPTArtist] { get }
        
    /**
     The markets in which the album is available: ISO 3166-1 alpha-2 country codes. Note that an album is considered available in a market when at least 1 of its tracks is available in that market.
     */
    var availableMarkets: [String] { get }
    
    /**
     The cover art for the album in various sizes, widest first.
     */
    var images: [SPTImage] { get }
    
    /**
     The precision with which release_date value is known: "year" , "month" , or "day".
     */
    var releaseDatePrecision: SPTDatePrecision { get }
    
    /**
     The date the album was first released.
     */
    var releaseDate: Date? { get }
    
    /**
     The copyright statements of the album.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var copyrights: [SPTCopyright]? { get }
    
    /**
     A list of the genres used to classify the album. For example: "Prog Rock" , "Post-Grunge". (If not yet classified, the array is empty.)
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var genres: [String]? { get }
    
    /**
     The label for the album.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var label: String? { get }
    
    /**
     The popularity of the album. The value will be between 0 and 100, with 100 being the most popular. The popularity is calculated from the popularity of the album’s individual tracks.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var popularity: Int? { get }
    
    /**
     The tracks of the album.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var tracks: SPTPagingObject<SPTTrack>? { get }
}

public extension SPTAlbumProtocol where Self: Nestable {
    static var pluralKey: String {
        return "albums"
    }
}

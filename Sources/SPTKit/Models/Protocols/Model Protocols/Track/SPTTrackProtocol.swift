//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation
public protocol SPTTrackProtocol: SPTBaseObjectProtocol, Nestable {
    
    /**
     The name of this track.
     */
    var name: String { get }
    
    /**
     The artists who performed the track.
     */
    var artists: [SPTArtist] { get }
    
    /**
     A list of the countries in which the track can be played, identified by their ISO 3166-1 alpha-2 code.
     */
    var availableMarkets: [String] { get }
    
    /**
     The disc number (usually 1 unless the album consists of more than one disc).
     */
    var discNumber: Int { get }
    
    /**
     The track length in milliseconds.
     */
    var durationMs: Int { get }
    
    /**
     Whether or not the track has explicit lyrics ( true = yes it does; false = no it does not OR unknown).
     */
    var isExplicit: Bool { get }
    
    /**
     Part of the response when Track Relinking is applied. If true, the track is playable in the given market. Otherwise false.
     */
    var isPlayable: Bool { get }
    
    /**
     Part of the response when Track Relinking is applied, and the requested track has been replaced with different track. The track in the linked_from object contains information about the originally requested track.
     */
    var linkedFrom: SPTLinkedTrack? { get }
    
    /**
     A link to a 30 second preview (MP3 format) of the track. Can be null
    */
    var previewURL: URL? { get }
    
    /**
     The number of the track. If an album has several discs, the track number is the number on the specified disc.
     */
    var trackNumber: Int { get }
    
    /**
     Whether or not the track is from a local file.
     */
    var isLocal: Bool { get }
    
    /**
     The album on which the track appears
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var album: SPTAlbum? { get }
    
    /**
     The popularity of the track. The value will be between 0 and 100, with 100 being the most popular.
     The popularity of a track is a value between 0 and 100, with 100 being the most popular. The popularity is calculated by algorithm and is based, in the most part, on the total number of plays the track has had and how recent those plays are.
     Generally speaking, songs that are being played a lot now will have a higher popularity than songs that were played a lot in the past. Duplicate tracks (e.g. the same track from a single and an album) are rated independently. Artist and album popularity is derived mathematically from track popularity. Note that the popularity value may lag actual popularity by a few days: the value is not updated in real time.
     
     - Warning: This value is always `nil` in simplified objects.
     */
    var popularity: Int? { get }
}

public extension SPTTrackProtocol where Self: Nestable {
    static var pluralKey: String {
        return "tracks"
    }
}

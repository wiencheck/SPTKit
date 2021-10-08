//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTSimplifiedTrackProtocol: SPTBaseObjectProtocol, Nestable {
    /**
     The name of this track.
     */
    var name: String { get }
    
    /**
     The artists who performed the track.
     */
    var artists: [SPTSimplifiedArtist] { get }
    
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
    var previewUrl: URL? { get }
    
    /**
     The number of the track. If an album has several discs, the track number is the number on the specified disc.
     */
    var trackNumber: Int { get }
    
    /**
     Whether or not the track is from a local file.
     */
    var isLocal: Bool { get }
}

public extension SPTSimplifiedTrackProtocol where Self: Nestable {
    static var pluralKey: String {
        return "tracks"
    }
}

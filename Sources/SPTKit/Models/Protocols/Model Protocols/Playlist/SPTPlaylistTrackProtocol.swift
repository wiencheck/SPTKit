//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTPlaylistTrackProtocol: Decodable {
    /**
     The date and time the track was added. Note that some very old playlists may return null in this field.
     */
    var addedDate: Date? { get }
    
    /**
     The Spotify user who added the track. Note that some very old playlists may return null in this field.
     */
    var addedBy: SPTPublicUser? { get }
    
    /**
     Whether this track is a local file or not.
     */
    var isLocal: Bool { get }
    
    /**
     Information about the track.
     */
    var track: SPTTrack { get }
}

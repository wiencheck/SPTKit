//
//  File.swift
//  
//
//  Created by Adam Wienconek on 06/08/2021.
//

import Foundation

public protocol SPTSimplifiedPlaylistProtocol: SPTBaseObjectProtocol, Nestable {
    /**
     true if the owner allows other users to modify the playlist.
     */
    var isCollaborative: Bool { get }
    
    /**
     The playlist description. Only returned for modified, verified playlists, otherwise null .
     */
    var descriptionText: String? { get }
    
    /**
     Images for the playlist. The array may be empty or contain up to three images. The images are returned by size in descending order. See Working with Playlists.
     Note: If returned, the source URL for the image ( url ) is temporary and will expire in less than a day.
     */
    var images: [SPTImage] { get }
    
    /**
     The name of the playlist.
     */
    var name: String { get }
    
    /**
     The user who owns the playlist
     */
    var owner: SPTPublicUser { get }
    
    /**
     The playlist’s public/private status: true the playlist is public, false the playlist is private, null the playlist status is not relevant. For more about public/private status, see [Working with Playlists](https://developer.spotify.com/documentation/general/guides/working-with-playlists/).
     */
    var isPublic: Bool? { get }
    
    /**
     The version identifier for the current playlist. Can be supplied in other requests to target a specific playlist version.
     */
    var snapshotId: String { get }
    
    /**
     Number of tracks in the playlist.
     */
    var total: Int { get }
}

public extension SPTSimplifiedPlaylistProtocol where Self: Nestable {
    static var pluralKey: String {
        return "playlists"
    }
}

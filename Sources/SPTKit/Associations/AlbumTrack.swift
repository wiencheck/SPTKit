//
//  File.swift
//  
//
//  Created by Adam Wienconek on 25/09/2021.
//

import Foundation
import GRDB

/// Helper struct for creating associations between album and its tracks.
public struct AlbumTrack: Codable, Hashable {
    
    public let albumId: SPTSimplifiedAlbum.ID
    public let trackId: SPTSimplifiedTrack.ID
        
    public init(albumId: SPTSimplifiedAlbum.ID, trackId: SPTSimplifiedTrack.ID) {
        self.albumId = albumId
        self.trackId = trackId
    }
}

extension AlbumTrack: GRDBRecord {
    
    static let track = belongsTo(SPTSimplifiedTrack.self)
    static let album = belongsTo(SPTSimplifiedAlbum.self)
    
    public static var databaseTableName: String { "albumTrack" }
    
    public static var migration: Migration {
        return ("createAlbumTrack", { db in
            try db.create(table: databaseTableName) { table in
                table.column("albumId", .text)
                    .notNull()
                    .references(SPTSimplifiedAlbum.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTSimplifiedTrack.databaseTableName, onDelete: .cascade)
                table.primaryKey(["albumId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTSimplifiedAlbum {
    private static let albumTracks = hasMany(AlbumTrack.self)
    private static let tracks = hasMany(SPTSimplifiedTrack.self,
                                        through: albumTracks,
                                        using: AlbumTrack.track)
    
    /// Request for fetching associated tracks from the local database.
    public var albumTracks: QueryInterfaceRequest<SPTSimplifiedTrack> {
        request(for: Self.tracks)
            .order(SPTSimplifiedTrack.Columns.trackNumber)
    }
}

extension SPTSimplifiedTrack {
    private static let trackAlbums = hasMany(AlbumTrack.self)
    private static let albums = hasMany(SPTSimplifiedAlbum.self,
                                        through: trackAlbums,
                                        using: AlbumTrack.album)
    
    /// Request for fetching associated albums from the local database.
    public var trackAlbums: QueryInterfaceRequest<SPTSimplifiedAlbum> {
        request(for: Self.albums)
    }
}

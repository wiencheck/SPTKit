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
    
    public let albumId: SPTAlbum.ID
    public let trackId: SPTTrack.ID
        
    public init(albumId: SPTAlbum.ID, trackId: SPTTrack.ID) {
        self.albumId = albumId
        self.trackId = trackId
    }
}

extension AlbumTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    static let album = belongsTo(SPTAlbum.self)
    
    public static var databaseTableName: String { "albumTrack" }
    
    public static var migration: Migration {
        return ("createAlbumTrack", { db in
            try db.create(table: databaseTableName) { table in
                table.column("albumId", .text)
                    .notNull()
                    .references(SPTAlbum.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTTrack.databaseTableName, onDelete: .cascade)
                table.primaryKey(["albumId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTAlbum {
    private static let albumTracks = hasMany(AlbumTrack.self)
    private static let tracks = hasMany(SPTTrack.self,
                                        through: albumTracks,
                                        using: AlbumTrack.track)
    
    /// Request for fetching associated tracks from the local database.
    public var albumTracks: QueryInterfaceRequest<SPTTrack> {
        request(for: Self.tracks)
            .order(SPTTrack.Columns.trackNumber)
    }
}

extension SPTTrack {
    private static let trackAlbums = hasMany(AlbumTrack.self)
    private static let albums = hasMany(SPTAlbum.self,
                                        through: trackAlbums,
                                        using: AlbumTrack.album)
    
    /// Request for fetching associated albums from the local database.
    public var trackAlbums: QueryInterfaceRequest<SPTAlbum> {
        request(for: Self.albums)
    }
}

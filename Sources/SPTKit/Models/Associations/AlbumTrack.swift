//
//  File.swift
//  
//
//  Created by Adam Wienconek on 25/09/2021.
//

import Foundation
import GRDB

public struct AlbumTrack: Codable, Hashable {
    public let albumId: String
    public let trackId: String
    
    public init(albumId: String, trackId: String) {
        self.albumId = albumId
        self.trackId = trackId
    }
}

extension AlbumTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    static let album = belongsTo(SPTAlbum.self)
    
    public static var migration: Migration {
        return ("createAlbumTrack", { db in
            try db.create(table: "albumTrack") { table in
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
    
    public var trackAlbums: QueryInterfaceRequest<SPTAlbum> {
        request(for: Self.albums)
    }
}

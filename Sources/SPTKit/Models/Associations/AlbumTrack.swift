//
//  File.swift
//  
//
//  Created by Adam Wienconek on 25/09/2021.
//

import Foundation
import GRDB

public struct AlbumTrack: Codable {
    public let albumId: String
    public let trackId: String
    
    public let position: Int
    
    public init(albumId: String, trackId: String, position: Int) {
        self.albumId = albumId
        self.trackId = trackId
        self.position = position
    }
}

extension AlbumTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    
    public static var migration: Migration {
        return ("createAlbumTrack", { db in
            try db.create(table: "albumTrack") { table in
                table.column("albumId", .text)
                    .notNull()
                    .references(SPTAlbum.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTTrack.databaseTableName, onDelete: .cascade)
                table.column("position", .integer)
                    .notNull()
                table.primaryKey(["albumId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTAlbum {
    private static let albumTracks = hasMany(AlbumTrack.self)
    private static let tracks = hasMany(SPTTrack.self,
                                        through: albumTracks.order(Column("position")),
                                        using: AlbumTrack.track)
    
    public var albumTracks: QueryInterfaceRequest<SPTTrack> {
        request(for: Self.tracks)
    }
}

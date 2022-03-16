//
//  File.swift
//  
//
//  Created by Adam Wienconek on 25/09/2021.
//

import Foundation
import GRDB

/// Helper struct for creating associations between playlist and its tracks.
public struct PlaylistTrack: Codable, Hashable {
    
    public let playlistId: SPTSimplifiedPlaylist.ID
    public let trackId: SPTSimplifiedTrack.ID
    
    public let position: Int
    public let addedDate: Date?
        
    public init(playlistId: SPTSimplifiedPlaylist.ID, trackId: SPTSimplifiedTrack.ID, position: Int, addedDate: Date?) {
        self.playlistId = playlistId
        self.trackId = trackId
        self.position = position
        self.addedDate = addedDate
    }
}

extension PlaylistTrack: GRDBRecord {
    
    static let track = belongsTo(SPTSimplifiedTrack.self)
    
    public static var databaseTableName: String { "playlistTrack" }
    
    public static var migration: Migration {
        return ("createPlaylistTrack", { db in
            try db.create(table: databaseTableName) { table in
                table.column("playlistId", .text)
                    .notNull()
                    .references(SPTSimplifiedPlaylist.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTSimplifiedTrack.databaseTableName, onDelete: .cascade)
                table.column("position", .integer)
                    .notNull()
                table.column("addedDate", .date)
                table.primaryKey(["playlistId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTSimplifiedPlaylist {
    private static let playlistTracks = hasMany(PlaylistTrack.self)
    private static let tracks = hasMany(SPTSimplifiedTrack.self,
                                        through: playlistTracks.order(Column("position")),
                                        using: PlaylistTrack.track)
    
    /// Request for fetching associated tracks from the local database.
    public var playlistTracks: QueryInterfaceRequest<SPTSimplifiedTrack> {
        request(for: Self.tracks)
    }
}

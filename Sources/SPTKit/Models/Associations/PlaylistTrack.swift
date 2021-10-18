//
//  File.swift
//  
//
//  Created by Adam Wienconek on 25/09/2021.
//

import Foundation
import GRDB

public struct PlaylistTrack: Codable, Hashable {
    public let playlistId: String
    public let trackId: String
    
    public let position: Int
    public let addedDate: Date?
    
    public init(playlistId: String, trackId: String, position: Int, addedDate: Date?) {
        self.playlistId = playlistId
        self.trackId = trackId
        self.position = position
        self.addedDate = addedDate
    }
}

extension PlaylistTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    
    public static var migration: Migration {
        return ("createPlaylistTrack", { db in
            try db.create(table: "playlistTrack") { table in
                table.column("playlistId", .text)
                    .notNull()
                    .references(SPTPlaylist.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTTrack.databaseTableName, onDelete: .cascade)
                table.column("position", .integer)
                    .notNull()
                table.column("addedDate", .date)
                table.primaryKey(["playlistId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTPlaylist {
    private static let playlistTracks = hasMany(PlaylistTrack.self)
    private static let tracks = hasMany(SPTTrack.self,
                                        through: playlistTracks.order(Column("position")),
                                        using: PlaylistTrack.track)
    
    public var playlistTracks: QueryInterfaceRequest<SPTTrack> {
        request(for: Self.tracks)
    }
}

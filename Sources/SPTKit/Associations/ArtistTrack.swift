//
//  File.swift
//  
//
//  Created by Adam Wienconek on 16/10/2021.
//

import Foundation
import GRDB

/// Helper struct for creating associations between artist and his/her tracks.
public struct ArtistTrack: Codable, Hashable {
    
    public let artistId: SPTSimplifiedArtist.ID
    public let trackId: SPTSimplifiedTrack.ID
        
    public init(artistId: SPTSimplifiedArtist.ID, trackId: SPTSimplifiedTrack.ID) {
        self.artistId = artistId
        self.trackId = trackId
    }
}

extension ArtistTrack: GRDBRecord {
    
    static let track = belongsTo(SPTSimplifiedTrack.self)
    
    public static var databaseTableName: String { "artistTrack" }
    
    public static var migration: Migration {
        return ("createArtistTrack", { db in
            try db.create(table: databaseTableName) { table in
                table.column("artistId", .text)
                    .notNull()
                    .references(SPTSimplifiedArtist.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTSimplifiedTrack.databaseTableName, onDelete: .cascade)
                table.primaryKey(["artistId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTSimplifiedArtist {
    private static let artistTracks = hasMany(ArtistTrack.self)
    private static let tracks = hasMany(SPTSimplifiedTrack.self,
                                        through: artistTracks,
                                        using: ArtistTrack.track)
    
    /// Request for fetching associated tracks from the local database.
    public var artistTracks: QueryInterfaceRequest<SPTSimplifiedTrack> {
        request(for: Self.tracks)
    }
}

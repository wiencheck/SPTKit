//
//  File.swift
//  
//
//  Created by Adam Wienconek on 16/10/2021.
//

import Foundation
import GRDB

public struct ArtistTrack: Codable, Hashable {
    public let artistId: String
    public let trackId: String
    
    public init(artistId: String, trackId: String) {
        self.artistId = artistId
        self.trackId = trackId
    }
}

extension ArtistTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    
    public static var migration: Migration {
        return ("createArtistTrack", { db in
            try db.create(table: "artistTrack") { table in
                table.column("artistId", .text)
                    .notNull()
                    .references(SPTArtist.databaseTableName, onDelete: .cascade)
                table.column("trackId", .text)
                    .notNull()
                    .references(SPTTrack.databaseTableName, onDelete: .cascade)
                table.primaryKey(["artistId", "trackId"], onConflict: .replace)
            }
        })
    }
}

extension SPTArtist {
    private static let artistTracks = hasMany(ArtistTrack.self)
    private static let tracks = hasMany(SPTTrack.self,
                                        through: artistTracks,
                                        using: ArtistTrack.track)
    
    public var artistTracks: QueryInterfaceRequest<SPTTrack> {
        request(for: Self.tracks)
    }
}

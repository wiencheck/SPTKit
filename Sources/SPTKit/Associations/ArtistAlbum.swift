//
//  File.swift
//  
//
//  Created by Adam Wienconek on 16/10/2021.
//

import Foundation
import GRDB

/// Helper struct for creating associations between artist and his/her albums.
public struct ArtistAlbum: Codable, Hashable {
    
    public let artistId: SPTSimplifiedArtist.ID
    public let albumId: SPTSimplifiedAlbum.ID
        
    public init(artistId: SPTSimplifiedArtist.ID, albumId: SPTSimplifiedAlbum.ID) {
        self.artistId = artistId
        self.albumId = albumId
    }
}

extension ArtistAlbum: GRDBRecord {
    
    static let album = belongsTo(SPTSimplifiedAlbum.self)
    
    public static var databaseTableName: String { "artistAlbum" }
    
    public static var migration: Migration {
        return ("createArtistAlbum", { db in
            try db.create(table: databaseTableName) { table in
                table.column("artistId", .text)
                    .notNull()
                    .references(SPTSimplifiedArtist.databaseTableName, onDelete: .cascade)
                table.column("albumId", .text)
                    .notNull()
                    .references(SPTSimplifiedAlbum.databaseTableName, onDelete: .cascade)
                table.primaryKey(["artistId", "albumId"], onConflict: .replace)
            }
        })
    }
}

extension SPTSimplifiedArtist {
    private static let artistAlbums = hasMany(ArtistAlbum.self)
    private static let albums = hasMany(SPTSimplifiedAlbum.self,
                                        through: artistAlbums,
                                        using: ArtistAlbum.album)
    
    /// Request for fetching associated albums from the local database.
    public var artistAlbums: QueryInterfaceRequest<SPTSimplifiedAlbum> {
        request(for: Self.albums)
    }
}


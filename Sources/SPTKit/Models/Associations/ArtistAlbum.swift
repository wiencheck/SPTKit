//
//  File.swift
//  
//
//  Created by Adam Wienconek on 16/10/2021.
//

import Foundation
import GRDB

public struct ArtistAlbum: Codable, Hashable {
    public let artistId: String
    public let albumId: String
    
    public init(artistId: String, albumId: String) {
        self.artistId = artistId
        self.albumId = albumId
    }
}

extension ArtistAlbum: GRDBRecord {
    
    static let album = belongsTo(SPTAlbum.self)
    
    public static var migration: Migration {
        return ("createArtistAlbum", { db in
            try db.create(table: "artistAlbum") { table in
                table.column("artistId", .text)
                    .notNull()
                    .references(SPTArtist.databaseTableName, onDelete: .cascade)
                table.column("albumId", .text)
                    .notNull()
                    .references(SPTAlbum.databaseTableName, onDelete: .cascade)
                table.primaryKey(["artistId", "albumId"], onConflict: .replace)
            }
        })
    }
}

extension SPTArtist {
    private static let artistAlbums = hasMany(ArtistAlbum.self)
    private static let albums = hasMany(SPTAlbum.self,
                                        through: artistAlbums,
                                        using: ArtistAlbum.album)
    
    public var artistAlbums: QueryInterfaceRequest<SPTAlbum> {
        request(for: Self.albums)
    }
}


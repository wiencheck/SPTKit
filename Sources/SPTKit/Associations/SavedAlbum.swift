//
//  File.swift
//  
//
//  Created by Adam Wienconek on 18/02/2022.
//

import Foundation
import GRDB

public struct SavedAlbum: Codable, Hashable {
    
    public let albumId: SPTAlbum.ID
    public let addedDate: Date
        
    public init(albumId: String, addedDate: Date) {
        self.albumId = albumId
        self.addedDate = addedDate
    }
}

extension SavedAlbum: GRDBRecord {
    
    static let album = belongsTo(SPTAlbum.self)
    
    public static var databaseTableName: String { "savedAlbum" }
    
    public static var migration: Migration {
        return ("createSavedAlbum", { db in
            try db.create(table: databaseTableName) { table in
                table.column("albumId", .text)
                    .primaryKey(onConflict: .replace)
                    .notNull()
                    .references(SPTAlbum.databaseTableName, onDelete: .cascade)
                table.column("addedDate", .date)
                    .notNull()
            }
        })
    }
}

extension SPTAlbum {
    
    private static let savedAlbum = hasOne(SavedAlbum.self)
    
    public var savedAlbum: QueryInterfaceRequest<SavedAlbum> {
        request(for: Self.savedAlbum)
    }
}

//
//  SavedTrack.swift
//  
//
//  Created by Adam Wienconek on 18/02/2022.
//

import Foundation
import GRDB

public struct SavedTrack: Codable, Hashable {
    
    public let trackId: SPTTrack.ID
    public let addedDate: Date
        
    public init(trackId: SPTTrack.ID, addedDate: Date) {
        self.trackId = trackId
        self.addedDate = addedDate
    }
}

extension SavedTrack: GRDBRecord {
    
    static let track = belongsTo(SPTTrack.self)
    
    public static var databaseTableName: String { "savedTrack" }
    
    public static var migration: Migration {
        return ("createSavedTrack", { db in
            try db.create(table: databaseTableName) { table in
                table.column("trackId", .text)
                    .primaryKey(onConflict: .replace)
                    .notNull()
                    .references(SPTTrack.databaseTableName, onDelete: .cascade)
                table.column("addedDate", .date)
                    .notNull()
            }
        })
    }
}

extension SPTTrack {
    
    private static let savedTrack = hasOne(SavedTrack.self)
    
    public var savedTrack: QueryInterfaceRequest<SavedTrack> {
        request(for: Self.savedTrack)
    }
}

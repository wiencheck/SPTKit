//
//  File.swift
//  
//
//  Created by Adam Wienconek on 20/10/2021.
//

import GRDB

public typealias Migration = (identifier: String, migrate: (Database) throws -> Void)

public protocol GRDBRecord: FetchableRecord, PersistableRecord {
    
    static var databaseTableName: String { get }
    static var migration: Migration { get }
}

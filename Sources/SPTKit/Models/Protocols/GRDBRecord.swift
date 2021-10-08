//
//  File.swift
//  
//
//  Created by Adam Wienconek on 09/08/2021.
//

import GRDB

public typealias Migration = (identifier: String, migrate: (Database) throws -> Void)

public protocol GRDBRecord: FetchableRecord & PersistableRecord {
    static var migration: Migration { get }
}
